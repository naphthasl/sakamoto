<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-GB">
	<head>
		<title>{{title}}</title>

		<meta name="description" content="Sakamoto Content Management System" />
		<meta name="author"      content="Naphtha Nepanthez" />
		
		<script type="text/javascript"><!--//--><![CDATA[//><!--
			function getParameterByName(name, url) {
				if (!url) url = window.location.href;
				name = name.replace(/[\[\]]/g, '\\$&');
				var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
					results = regex.exec(url);
				if (!results) return null;
				if (!results[2]) return '';
				return decodeURIComponent(results[2].replace(/\+/g, ' '));
			}
			
			function getJSON(url, callback) {
				var xhr = new XMLHttpRequest();
				xhr.open('GET', url, true);
				xhr.responseType = 'json';
				xhr.onload = function() {
					var status = xhr.status;
					if (status === 200) {
						callback(null, xhr.response);
					} else {
						callback(status, xhr.response);
					}
				};
				xhr.send();
			};

			if (!String.prototype.includes) {
				String.prototype.includes = function(search, start) {
					'use strict';
					if (typeof start !== 'number') {
						start = 0;
					}

					if (start + search.length > this.length) {
						return false;
					} else {
						return this.indexOf(search, start) !== -1;
					}
				};
			}

			if (!String.prototype.format) {
				String.prototype.format = function() {
					var args = arguments;
					return this.replace(/{(\d+)}/g, function(match, number) { 
						return typeof args[number] != 'undefined'
							? args[number]
							: match
						;
					});
				};
			}

			function text_truncate(str, length, ending) {
				if (str.length > length) {
					return str.substring(0, length - ending.length) + ending;
				} else {
					return str;
				}
			};
			
			function menuLinkCheck() {
				document.getElementById('menu').contentDocument.querySelectorAll('a').forEach(function(node) {
					if (!node.className.split(' ').includes('auto')) {
						if (node.href == document.getElementById('content').contentWindow.location.href) {
							node.style.fontWeight = 'bold';
						} else {
							node.style.fontWeight = 'normal';
						}
					}
				});
			}

			function setNavbar(contents) {
				var content_location = document.getElementById('content').contentWindow.location.href;
				var content_breadcrumb = document.getElementById('navbar').contentDocument.getElementById('breadcrumb-menu');

				if (contents == null) {
					contents = [];

					/*
					// THIS IS HORRIBLE, AN ACTUAL NIGHTMARE!
					var usplit = content_location.replace(window.location.href.split('/').slice(0, -1).join('/'), '').substr(1);
					if (usplit.includes('?')) {
						usplit = usplit.split('?').slice(0, -1).join();
					}
					usplit = usplit.split('/');

					console.log(usplit);
					usplit.forEach(function(node, key) {
						console.log(key);
						newurl = './' + usplit.slice(0, key + 1).join('/')

						console.log(newurl);
					});
					*/
				} else {
					contents = contents[content_location.split('/').pop().split('?').shift()];
				}

				content_breadcrumb.innerHTML = '';

				contents.forEach(function(node) {
					var add_node = document.createElement("li");   
					add_node.innerHTML = '<a href="{0}">{1}</a>'.format(node.url, text_truncate(node.name, 16, '...'));

					content_breadcrumb.appendChild(add_node);
				});
			}
			
			window.onload = function() {
				var content = document.getElementById('content');
				var navbar  = document.getElementById('navbar');
				var menu    = document.getElementById('menu');
				
				content.onload = function() {
					menuLinkCheck();
					
					var location = content.contentWindow.location.href;
					
					if (location.includes('document')) {
						documentid = location.split('/').pop().split('?').shift();

						if (history.pushState) {
							history.pushState({}, null, '?doc=' + documentid);
						}

						getJSON('./breadcrumbs', function(err, data) {
							if (err !== null) {
								setNavbar(null);
							} else {
								setNavbar(data);
							}
						});
					} else {
						if (history.pushState) {
							history.pushState({}, null, './');
						}

						setNavbar(null);
					}
				}

				content.onload();
				menuLinkCheck();
				
				menu.onload = function() {
					navbar.contentWindow.location.reload();
				}
			}
			
		//--><!]]></script>
	</head>
	<frameset rows="64px,*" border=0 frameborder=0 framespacing=0>
		<frame id="navbar" name="navbar" src="./navbar" noresize />
		<frameset cols="240px,*" class="sep" border=0 frameborder=0 framespacing=0> <!-- 240px,740px,* -->
			<frame id="menu"    name="menu"    src="./menu" noresize />
			<frame id="content" name="content" src="{{content}}" noresize />
			<!--<frame id="filler"  name="filler"  src="about:blank" noresize />-->
		</frameset>
		<noframes>
			<p>Your browser does not support framesets. Considering the current only alternative to framesets is an extremely buggy JavaScript library (wait, isn't that all JavaScript libraries?), you just won't be able to access this page.</p>
		</noframes>
	</frameset>
</html>
