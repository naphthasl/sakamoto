<%
from datetime import datetime
import base64
import xxhash
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>document</title>
		
		<link rel="stylesheet" href="../static/main.css" />
		<base target="_top" />
	</head>
	<body>
		<span style="display: none;" id="document-id">{{id}}</span>
		
		<% if not (index == None): %>
			<div class="document-children">
				{{!index}}
			</div>
		<% end %>
		
		<pre class="markdown" id="markdown" style="display: none;">{{base64.b64encode(markdown.encode()).decode()}}</pre>
		<div class="content" id="content"></div>
		
		<% if not (comments == None): %>
			<div class="comments">
				<div class="comment-form">
					<% if user['login'] == True: %>
						<form action="./{{id}}" method="POST" target="_self" id="comment-form-inner" class="comment-form-inner">
							<table>
								<tr>
									<td id="commenttd">
										<textarea form="comment-form-inner" id="input" name="input" rows="1" placeholder="Leave a comment..."></textarea>
									</td>
									<td>
										<input type="hidden" id="type" name="type" value="comment" />
										<input type="submit" id="submit" name="submit" value="Submit" />
									</td>
								</tr>
							</table>
						</form> 
					<% else: %>
						<table>
							<tr>
								<td>
									Log in or register to post a comment.
								</td>
							</tr>
						</table>
					<% end %>
				</div>
				
				<% for k, v in comments.items(): %>
					<div class="individual-comment">
						<svg class="avatar" width="32" height="32" data-jdenticon-value="{{xxhash.xxh64(v['author'].encode()).hexdigest()}}"></svg>

						<div class="comment-text">
							<span class="author">{{v['author']}}</span> 
							<span class="date">{{datetime.utcfromtimestamp(v['created']).strftime('%Y-%m-%d %H:%M:%S')}} UTC</span>
							<br />
							<span class="message">{{v['content']}}</span>
						</div>

						<% if (user['name'] == v['author']) or user['admin']: %>
							<span class="decomment"><a href="?decomment={{k}}" target="_self"><span class="icon icon-cross"></span></a></span>
						<% end %>
					</div>
				<% end %>
				
				<div class="pages">
					<ul>
						<%
							if pages > 1:
								for x in range(pages):
						%>
									<li class="pagelink{{' selected' if x == int(page) else ''}}"><a href="?page={{x}}" target="_self">{{x}}</a></li>
						<%
								end
							end
						%>
					</ul>
				</div>
			</div>
		<% end %>
		
		<script
			src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
			integrity="sha256-4+XzXVhsDmqanXGHaHvgh1gMQKX40OUvDEBTu8JcmNs="
			crossorigin="anonymous"></script>

		<script type="text/javascript" src="../static/autosize/dist/autosize.min.js"></script>
		<script type="text/javascript" src="../static/marked/marked.min.js"></script>
		<script type="text/javascript">
			window.addEventListener('load', function() {
				document.getElementById('content').innerHTML = marked(atob(document.getElementById('markdown').innerHTML));
				document.getElementById('markdown').remove();

				autosize(document.querySelector('.comment-form-inner #input'));

				document.querySelectorAll('#content a').forEach(function(node) {
					if (node.getAttribute('href').startsWith('#')) {
						node.target = '_self';
					}
				});
			}, false);
		</script>
		
		<script type="text/javascript" src="../static/shared_document.js"></script>
		<script type="text/javascript" src="../static/jdenticon/dist/jdenticon.min.js"></script>
	</body>
</html>
