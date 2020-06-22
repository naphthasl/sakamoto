"""
Sakamoto is a basic but somewhat adorable content management system,
inspired by a previous project for viewing Python module documentation.

It has the end goal of being simple but useful as well as extremely easy
to understand and modify.

Plus, the default UI theme looks cool!
"""

__author__ = 'Naphtha Nepanthez'
__version__ = 'RBMK-1000'
__license__ = 'AGPL-v3.0' # SEE LICENSE FILE

# TODO: B e c o m e   s t a b l e .
# No, seriously. Versions beginning with RBMK could explode at any moment.

import os
os.chdir(os.path.dirname(os.path.realpath(__file__)))

import bcrypt, time, base64, json, random, io, string, pickle, mimetypes
import html, pytz, math, xxhash

from collections.abc import MutableMapping
from bottle import Bottle, run, request, response
from bottle import redirect, abort, template, static_file
from pony.orm import *
from datetime import datetime
from pathlib import Path
from operator import is_not
from functools import partial
from claptcha import Claptcha
from PIL import Image

acceptable_username_set = set(
	string.ascii_lowercase
	+ string.digits
	+ '_-@!?./+'
)

def image_destroyer(im):
	im = im.convert('RGBA')
	r, g, b, a = im.split()

	a = a.point(lambda i: round(i / 255) * 255)

	im = Image.merge('RGBA', (r, g, b, a))
	im = im.convert('P', colors = 32, dither = None).convert('RGBA')

	return im

icons = {}
for x in filter(partial(is_not, None), map(
	(lambda x: x if 'image/' in mimetypes.guess_type(
		x, strict = False
	)[0] else None),
	list(Path("./static/icons").rglob("*.*")))):

	im = Image.open(x)
	byteim = io.BytesIO()
	im = image_destroyer(im.resize((16, 16)))

	im.save(byteim, "PNG")
	byteim.seek(0)

	icons[str(x)] = 'data:{0};charset=utf-8;base64,{1}'.format(
		'image/png',
		base64.b64encode(byteim.read()).decode()
	)

db = Database()

class Page(db.Entity):
	id       = PrimaryKey(int, auto=True)
	name     = Required  (str)
	icon     = Required  (str)
	position = Required  (int)
	disabled = Required  (bool)
	index    = Required  (bool)
	hidden   = Required  (bool)
	etarget  = Required  (bool)
	content  = Required  (str)
	parent   = Required  (int)
	
class User(db.Entity):
	name     = PrimaryKey(str)
	auth     = Required  (bytes)
	admin    = Required  (bool)
	
class Token(db.Entity):
	token    = PrimaryKey(bytes)
	name     = Required  (str)
	created  = Required  (int)
	
class Captcha(db.Entity):
	id       = PrimaryKey(int, auto=True)
	image    = Required  (bytes)
	code     = Required  (str)
	created  = Required  (int)
	
class Option(db.Entity):
	key      = PrimaryKey(bytes)
	value    = Required  (bytes)
	
class StaticFile(db.Entity):
	id       = PrimaryKey(int, auto=True)
	created  = Required  (int)
	original = Required  (str)
	length   = Required  (int)
	content  = Required  (bytes)
	
class Comment(db.Entity):
	id       = PrimaryKey(int, auto=True)
	parent   = Required  (int)
	author   = Required  (str)
	content  = Required  (str)
	created  = Required  (int)

db.bind(
	provider='sqlite',
	filename='test.db',
	create_db = True
)

db.generate_mapping(create_tables=True)

class InternalOptions(MutableMapping):
	@db_session
	def __init__(self, data: dict = {}):
		self.mapping = {}
		for x in select(p for p in Option):
			self.mapping[pickle.loads(x.key)] = pickle.loads(x.value)
		
		self.update(data)
		
		commit()
	@db_session
	def __getitem__(self, key):
		try:
			value = pickle.loads(Option.get(key = pickle.dumps(key)).value)
		except AttributeError:
			raise KeyError()
		
		self.mapping[key] = value
		commit()
		
		return value
	@db_session
	def __delitem__(self, key):
		Option.get(key = pickle.dumps(key)).delete()
		del self.mapping[key]
		
		commit()
	@db_session
	def __setitem__(self, key, value):
		try:
			Option.get(key = pickle.dumps(key)).value = pickle.dumps(value)
		except AttributeError:
			Option(key = pickle.dumps(key), value = pickle.dumps(value))
			
		self.mapping[key] = value
		
		commit()
	def __iter__(self):
		return iter(self.mapping)
	def __len__(self):
		return len(self.mapping)
	def __repr__(self):
		return '{0}({1})'.format(
			type(self).__name__,
			self.mapping
		)

OPTIONS = InternalOptions()

# Insert new options here.
try:
	OPTIONS['title'                 ]
	OPTIONS['static_upload_max_size']
	OPTIONS['allow_comments'        ]
	OPTIONS['dangerous_tips'        ]
except KeyError:
	OPTIONS['title'                 ] = 'Sakamoto'
	OPTIONS['static_upload_max_size'] = 8388608
	OPTIONS['allow_comments'        ] = True
	OPTIONS['dangerous_tips'        ] = False

tips = json.loads(open('./tips.json', 'r').read())

def get_tip(page: str = None):
	if OPTIONS['dangerous_tips']:
		txt = 'Unfriendly Tip: '
		ret = random.choice(tips['dangerous'])
	else:
		txt = 'Random Tip: '
		if page:
			ret = random.choice(tips[page])
		else:
			alltips = []
			for k, v in tips.items():
				alltips.append(v)
			
			ret = random.choice(alltips)
	
	return '<span class="icon icon-lightbulb"></span> ' + txt + ret

app = Bottle()

default_content = json.dumps({
	'external': False,
	'markdown': 'Hello world!',
	'link'    : '',
})

# Initial Startup
try:
	with db_session:
		defaults = json.loads(open('./config.json', 'r').read())
		
		Page(
			id       = -1,
			name     = 'Home',
			icon     = './static/home.png',
			position = 0,
			disabled = False,
			index    = False,
			hidden   = False,
			etarget  = False,
			content  = default_content,
			parent   = -2
		)

		User(
			name  = defaults['init_adminaccount']['username'],
			auth  = bcrypt.hashpw(
				defaults['init_adminaccount']['password'].encode(),
				bcrypt.gensalt()
			),
			admin = True
		)
		
		commit()
except core.TransactionIntegrityError:
	pass

# UTILITY
@db_session
def user_details(token: str):
	old = token
	
	try:
		token = Token.get(token = base64.b64decode(token))
		if (time.time() - token.created) > 604800:
			token.delete()
			
			raise Exception('Token expired!')

		user = User.get(name = token.name)
	except:
		return {
			'login': False,
			'name': 'default',
			'admin': False,
			'token': 'aW52YWxpZA=='
		}
		
	return {
		'login': True,
		'name': user.name,
		'admin': user.admin,
		'token': old
	}

@db_session
def get_page_parents(id: int):
	parents = []

	while id != -1:
		id = Page.get(id = id).parent
		parents.append(id)

	return list(reversed(parents))

@db_session
def breadcrumb_data():
	document_breadcrumbs = {}
	for x in select(p for p in Page):
		document_breadcrumbs[x.id] = []

		for y in get_page_parents(x.id):
			npg = Page.get(id = y)

			document_breadcrumbs[x.id].append({
				'url': './document/{0}'.format(y),
				'name': npg.name,
				'disabled': npg.disabled
			})

		document_breadcrumbs[x.id].append({
			'url': './document/{0}'.format(x.id),
			'name': x.name,
			'disabled': x.disabled
		})
	
	return document_breadcrumbs

def errorout(navback: str, error: str):
	# This is used to allow an error to be thrown at any route level

	redirect(
		os.path.join(
			navback,
			'./error'
		) + '?error=' + base64.urlsafe_b64encode(
			error.encode()
		).decode()
	)
	
@db_session
def gen_captcha():
	# NOTE: This causes an invalid pointer or segfault on some systems.
	# See https://github.com/naphthasl/sakamoto/issues/7

	code = ''.join([
		str(random.choice(string.hexdigits)) for _ in range(6)
	])

	x = Captcha(
		image   = Claptcha(
			source = code,
			font   = "./static/freemono/FreeMono.ttf",
			noise  = 0.3
		).bytes[1].read(),
		code    = code,
		created = round(time.time())
	)

	commit()
	
	return x.id

@db_session
def validate_captcha():
	cid = request.forms.get('captchaid').strip()
	try:
		if not (int(cid) in select(p.id for p in Captcha)[:]):
			errorout('./', 'Captcha expired.')
	except:
		errorout('./', 'Invalid Captcha.')
	
	captcha = Captcha.get(id=cid)
	captcha_code = captcha.code
	captcha.delete()
	commit()
	if request.forms.get('captcha').strip() != captcha_code:
		errorout('./', 'Captcha failed.')

def check_admin():
	# If the current user isn't an admin, throws an abort exception.

	if not user_details(request.get_cookie("token"))['admin']:
		abort(401, "Sorry, access denied.")

@db_session
def recurse(pid: int = -2, admin: bool = False, callroot: bool = True):
	# TODO: Make this not ugly. This is terrible, and I don't like it
	# at all. There really ought to be a better way to do this.

	layout = ''
	root = './'
	
	for p in select(
			p for p in Page if p.parent == pid
		).order_by(Page.position):

		children = recurse(pid = p.id, admin = admin, callroot = False)
		
		if (not p.hidden) or admin:
			icon = '<img width="16" height="16" src="{0}" />'.format(
				os.path.join(root, html.escape(p.icon))
			)

			actions = (
				lambda: (
					'<div class="adminopt"><span class="id">{0}</span>'
					+ '<a class="actions" href="{1}actions/{0}" '
					+ 'target="content">Actions</a></div>'
				).format(
					p.id,
					root
				) if admin else ''
			)()
			
			dclass = (
				lambda: ' class="tree-pre-collapsed"' if p.index else ''
			)()

			if p.disabled:
				layout += ('<li{3}><div class="menutext">{0} <div class="act">{1}'
					+ '</div> {2}</div>').format(
						icon,
						html.escape(p.name),
						actions,
						dclass
					)
			else:
				layout += (
					'<li{5}><div class="menutext">{0} <div class="act"><a '
					+ 'href="{4}document/{1}" target="content">{2}</a></div>'
					+ ' {3} </div>'
				).format(
					icon,
					p.id,
					html.escape(p.name),
					actions,
					root,
					dclass
				)

			# NOTE: Normally, the template engine would escape rogue HTML
			# entities, but since the rescursive tree is going to be included
			# with template value escape explicitly disabled, we have to escape
			# values like the document name ourselves.
				
			layout += children + '</li>\n'
		
	if layout == '':
		return layout
	else:
		return '<ul{0}>\n'.format(
			(lambda x: ' class="ul-root"' if x else '')(callroot)
		) + layout + '</ul>\n'

# DOCUMENTS
@app.get('/document/<id:int>')
@db_session
def document(id):
	# TODO: Find some sort of alternative to dynamic routing.
	# It makes assets extremely hard to reach, as they have to be
	# accessed relatively instead of through an absolute path.
	# (You never know how the user might host Sakamoto!)

	# helper: *deep level route*

	user = user_details(request.get_cookie("token"))
	pageobj = Page.get(id=id)
	
	if request.query.decomment and OPTIONS['allow_comments']:
		check_admin()
		
		comment = Comment.get(id=int(request.query.decomment))
		if comment:
			comment.delete()
			commit()

		# Don't need to add a redirect here because the database
		# commit is good enough. The rest of the page should load
		# without the deleted comment.
	
	content = json.loads(pageobj.content)
	
	if not ((pageobj.disabled) and (not user['admin'])):
		if content['external'] and len(content['link']) > 0:
			if pageobj.etarget == False:
				return template(
					'redirect',
					redirect=content['link']
				)
			else:
				return template(
					'redirect',
					redirect='../?ref='+content['link']
				)
		else:
			page = int(request.query.page or 0)

			if OPTIONS['allow_comments']:
				
				dbcomments = select(
					p for p in Comment if p.parent == id
				).order_by(desc(Comment.created))

				pages = math.ceil(len(dbcomments) / 8)
				
				comments = {}
				for p in dbcomments[page*8:(page+1)*8]:
					comments[p.id] = {
						'author': p.author,
						'content': p.content,
						'created': p.created
					} 
			else:
				pages = None
				comments = None
			
			return template(
				'document',
				markdown = content['markdown'],
				id       = id,
				index    = None,
				comments = comments,
				pages    = pages,
				page     = page,
				user     = user_details(request.get_cookie("token"))
			)
	else:
		abort(401, "Sorry, access denied.")
		
@app.post('/document/<id:int>')
@db_session
def do_document(id):
	# helper: *deep level route*
	
	user = user_details(request.get_cookie("token"))
	if not user['login']:
		abort(401, "Sorry, access denied.")
		
	ACT = request.forms.get('type')
		
	if ACT == 'comment' and OPTIONS['allow_comments']:
		if ((not request.forms.get('input').strip())
			or (len(request.forms.get('input')) > 2048)):

			errorout(
				'../',
				'You can\'t comment nothing, and you can\'t post more than '
				+ '2048 characters.'
			)
		
		Comment(
			parent  = id,
			author  = user['name'],
			content = request.forms.get('input'),
			created = round(time.time())
		)

		commit()
		
	redirect('./{0}'.format(id))

# MENU
@app.get('/menu')
def menu():
	user = user_details(request.get_cookie("token"))
	
	return template(
		'menu',
		content    = recurse(
			admin  = user['admin']
		),
		user       = user_details(
			request.get_cookie("token")
		)
	)

# ACTIONS
@app.get('/actions/<dobject:int>')
@db_session
def actions(dobject: int):
	# helper: *deep level route*
	
	check_admin()
	
	try:
		pobject = Page.get(id=dobject)
		properties = {
			'disabled': pobject.disabled,
			'index': pobject.index,
			'hidden': pobject.hidden,
			'name': pobject.name,
			'etarget': pobject.etarget
		}
	except:
		properties = {}
	
	return template(
		'actions',
		dobject   = dobject,
		rldmenu   = (bool(request.query.menu) or False),
		pageprops = properties,
		tip       = get_tip('actions')
	)
	
@app.get('/action/<dobject:int>')
@db_session
def actionstep(dobject: int):
	# helper: *deep level route*

	# TODO: This is also ugly. Big if/else statement. Not too big,
	# but still big.

	check_admin()

	pg = Page.get(id=dobject)

	if request.query.type == 'child':
		try:
			new_position = max(
				select(
					p.position for p in Page if p.parent == dobject
				)[:]
			) + 1
		except:
			new_position = 0
		
		Page(
			name     = 'New Menu Object',
			icon     = 'static/icons/tango/mimetypes/text-x-generic.png',
			position = new_position,
			disabled = True,
			index    = False,
			hidden   = False,
			etarget  = False,
			content  = default_content,
			parent   = dobject
		)

		commit()
		
		redirect('../menu')
	elif request.query.type == 'edit':
		return template(
			'editor',
			dobject         = dobject,
			content         = pg.content,
			default_content = default_content
		)
	else:
		if dobject != -1:
			if request.query.type == 'rename':
				return template(
					'rename',
					dobject = dobject,
					type    = 'rename',
					hint    = 'New Name',
					default = pg.name
				)
			elif request.query.type == 'chicon':
				return template(
					'iconpicker',
					icons   = icons,
					name    = pg.name,
					dobject = dobject,
					default = pg.icon
				)
			elif request.query.type == 'delete':
				@db_session
				def delete_object(object_id):
					Page.get(id=object_id).delete()
					for p in select(p for p in Page if p.parent == object_id):
						delete_object(p.id)
					
				delete_object(dobject)
				commit()
				
				redirect('../fullreload')
			elif request.query.type == 'move':
				parentid = pg.parent
				pages = dict(
					enumerate(
						select(
							p for p in Page if p.parent == parentid
						).order_by(Page.position)[:]
					)
				)
				
				for k, v in pages.items():
					if v.id == dobject:
						current_index = k
					
				try:
					nexte = pages[current_index + int(request.query.direction)]
				except KeyError:
					# Redirect back to the menu without performing any actions
					# in the event that the page cannot be moved up or down.
					redirect('../menu')
					
				current = pages[current_index]
				
				temp = current.position
				current.position = nexte.position
				nexte.position = temp
				
				commit()
				redirect('../menu')
			elif request.query.type == 'parent':
				return template(
					'rename',
					dobject = dobject,
					type    = 'parent',
					hint    = 'New Parent ID',
					default = pg.parent
				)
			elif request.query.type == 'disabled':
				pg.disabled = not pg.disabled
			elif request.query.type == 'index':
				pg.index = not pg.index
			elif request.query.type == 'hidden':
				pg.hidden = not pg.hidden
			elif request.query.type == 'etarget':
				pg.etarget = not pg.etarget
		else:
			errorout(
				'../',
				'You cannot perform this action on the root tree element.'
			)

	commit()
	redirect('../actions/{0}?menu=1'.format(dobject))

@app.post('/action/do')
@db_session
def actiondo():
	# Any page actions that require a form will send POST data to
	# this function.

	# helper: *deep level route*

	check_admin()
	
	acttype = str(request.forms.get('type'))
	dobject = int(request.forms.get('id'))
	
	if acttype == 'rename':
		Page.get(id=dobject).name = request.forms.get('input')
	elif acttype == 'chicon':
		Page.get(id=dobject).icon = request.forms.get('input')
	elif acttype == 'parent':
		try:
			newid = int(request.forms.get('input'))
		except:
			errorout('../', 'The parent ID specified is invalid!')
		
		if newid != -1:
			try:
				if not Page.get(id=newid).name:
					raise Exception('parent error')
			except:
				errorout('../', 'The parent ID does not exist!')
		
		try:
			new_position = max(
				select(
					p.position for p in Page if p.parent == newid
				)[:]
			) + 1
		except:
			new_position = 0
		
		Page.get(id=dobject).parent = newid
		Page.get(id=dobject).position = new_position
	elif acttype == 'edit':
		Page.get(id=dobject).content = json.dumps({
			'markdown': request.forms.get('markdown'),
			'external': bool(request.forms.get('external')),
			'link': request.forms.get('link')
		})

	commit()
	redirect('../actions/{0}?menu=1'.format(dobject))

# USER ACCOUNTS SYSTEM
@app.get('/login')
def login():
	return template('login',  captcha=gen_captcha())
	
@app.get('/logout')
@db_session
def logout():
	user = user_details(request.get_cookie("token"))
	
	if user['login']:
		response.set_cookie("token", "aW52YWxpZA==")
		
		Token.get(token = base64.b64decode(user['token'])).delete()
		
	return template('redirect', redirect='./reload')
	
@app.post('/login')
@db_session
def do_login():
	validate_captcha()
	
	username = request.forms.get('username').strip().lower()
	password = request.forms.get('password')
	
	token = os.urandom(48)
	
	try:
		if bcrypt.checkpw(password.encode(), User.get(name = username).auth):
			Token(
				token   = token,
				name    = username,
				created = round(time.time())
			)

			commit()
		else:
			raise Exception('Invalid Password')
	except:
		errorout('./', 'Invalid username or password.')
		
	response.set_cookie("token", base64.b64encode(token).decode())
		
	return template('redirect', redirect='./reload')

@app.get('/register')
def register():
	return template('register', captcha=gen_captcha(), tip=get_tip('register'))
	
@app.post('/register')
@db_session
def do_register():
	validate_captcha()
	
	password = request.forms.get('password')
	username = request.forms.get('username').strip()
	
	if ((len(username) > 24)
		or (len(username) < 4)
		or (len(password) > 128)
		or (len(password) < 4)
		or (not acceptable_username_set.issuperset(username))):

		errorout(
			'./',
			'Username or password does not conform to requirements.'
		)
	
	if password != request.forms.get('password2'):
		errorout('./', 'Passwords did not match.')
		
	if len(select(p for p in User if p.name == username)[:]) > 0:
		errorout('./', 'User already exists!')
		
	token = os.urandom(48)
	User(
		name = username,
		auth = bcrypt.hashpw(
			password.encode(),
			bcrypt.gensalt()
		),
		admin = False
	)

	Token(
		token = token,
		name = username,
		created = round(time.time())
	)

	response.set_cookie("token", base64.b64encode(token).decode())
	commit()
	
	return template('redirect', redirect='./reload')

@app.get('/password')
def newpassword():
	user = user_details(request.get_cookie("token"))
	if not user['login']:
		abort(401, "Sorry, access denied.")
	
	return template(
		'rename',
		hint    = 'New Password',
		type    = 'password',
		dobject = user['name'],
		default = ''
	)

@app.post('/password')
@db_session
def newpassworddo():
	user = user_details(request.get_cookie("token"))
	if not user['login']:
		abort(401, "Sorry, access denied.")
		
	password = request.forms.get('input')
	if len(password) > 128 or len(password) < 4:
		errorout('./', 'Passwords must be under 128 characters.')
		
	user = User.get(name=user['name'])
	user.auth = bcrypt.hashpw(
		password.encode(),
		bcrypt.gensalt()
	)
	
	commit()
	return template('redirect', redirect='./reload')

@app.get('/captcha/<id:int>')
@db_session
def captchaimg(id):
	# helper: *deep level route*

	response.set_header('Content-Type', 'image/png')
	
	captcha = Captcha.get(id=id)
	image = io.BytesIO(captcha.image)
	captcha.image = b'used'
	commit()

	return image

# OPTIONS
@app.get('/options')
def options():
	check_admin()
	
	return template('options', items=dict(OPTIONS))

@app.post('/options')
def do_register():
	check_admin()
	
	for k, v in dict(request.forms).items():
		try:
			try:
				_ = json.loads(k)
			except json.decoder.JSONDecodeError:
				continue

			if json.loads(k) in OPTIONS:
				if type(json.loads(v)) != type(OPTIONS[json.loads(k)]):
					errorout(
						'./',
						'JSON type mismatch error! Check the'
						+ ' formatting and spelling of your input.'
					)
				
				OPTIONS[json.loads(k)] = json.loads(v)
		except json.decoder.JSONDecodeError:
			errorout(
				'./',
				'JSONDecodeError! Check the formatting of your input.'
			)
			
	return template('redirect', redirect='./reload')

# FILE MANAGEMENT
@app.get('/files')
@db_session
def files():
	check_admin()
	
	if request.query.action == 'delete':
		rfile = StaticFile.get(id=int(request.query.id))
		rfile.delete()
		commit()
	
	filelist = {}
	for x in select(p for p in StaticFile):
		filelist[x.id] = {
			'created': x.created,
			'original': x.original,
			'length': x.length
		}
	
	return template('filelist', filelist=filelist)

@app.post('/files')
@db_session
def fileupload():
	check_admin()
	
	upload = request.files.get('fileselect')
	
	read = upload.file.read()
	if len(read) > OPTIONS['static_upload_max_size']:
		errorout('./', 'Upload too big, maximum size is {0} bytes.'.format(
			OPTIONS['static_upload_max_size']
		))
	
	StaticFile(
		created  = round(time.time()),
		original = upload.filename,
		length   = len(read),
		content  = read
	)

	commit()
	
	redirect('./files')
	

@app.get('/files/<id:int>')
@db_session
def filesget(id):
	# helper: *deep level route*

	rfile = StaticFile.get(id=id)
	mimetype = (lambda x: 'application/octet-stream' if x == None else x)(
		mimetypes.guess_type(rfile.original, strict = True)
	)
	response.set_header('Accept-Ranges', 'bytes')
	response.set_header('Content-Length', str(rfile.length))
	response.set_header('Content-Type', mimetype)
	response.set_header(
		'Last-Modified',
		datetime.fromtimestamp(
			rfile.created,
			tz=pytz.timezone('GMT')
		).strftime('%a, %d %b %Y %H:%M:%S GMT')
	)
	response.set_header('ETag', '"{0}"'.format(
		xxhash.xxh64(rfile.content).hexdigest()
	))
	
	return io.BytesIO(rfile.content)

# JSON API
@app.get('/breadcrumbs')
def breadcrumbs():
	return breadcrumb_data()

# GENERIC
@app.get('/help')
def dochelp():
	# TODO: Actually add internal documentation - some sort of quickstart
	# guide so people can figure out how to use Sakamoto for their own site
	# quickly.

	errorout('./', 'Internal documentation unfinished.')

@app.get('/fullreload')
def fullreload():
	return template('redirect', redirect = './reload')

@app.get('/error')
def error():
	return template(
		'error',
		error = base64.urlsafe_b64decode(request.query.error).decode()
	)

@app.get('/reload')
def reload():
	redirect("./")

@app.get('/navbar')
def navbar():
	return template(
		'navbar',
		user    = user_details(request.get_cookie("token")),
		options = OPTIONS
	)

@app.get('/credits')
def credits():
	check_admin()

	return template('credits')

@app.get('/')
@db_session
def home():
	# TODO: Find some way to make token and captcha cleanup faster on larger
	# sites.

	for x in (
			select(p for p in Token if (time.time() - p.created) > 604800)[:]
			+ select(p for p in Captcha if (time.time() - p.created) > 3600)[:]
		):

		x.delete()

	commit()

	if request.query.ref:
		content = request.query.ref
	elif request.query.doc:
		content = './document/'+request.query.doc
	else:
		content = './document/-1'
	
	return template('view', title=OPTIONS['title'], content=content)

@app.route('/static/<filepath:path>')
def server_static(filepath):
	# NOTE: This is a deep route, but that's fine.
	# This is the ONLY one that I find okay.

	return static_file(filepath, root='./static')

# TODO: Add production use mode. Eventually. When you can
# *actually* use the project in production.
run(app, host='0.0.0.0', port=8080, reloader=True, debug=True)
