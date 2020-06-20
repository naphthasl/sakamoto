<%
from datetime import datetime
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
		
		<div class="markdown" id="markdown" style="display: none;">{{markdown}}</div>
		<div class="content" id="content"></div>
		
		<% if not (comments == None): %>
			<div class="comments">
				<div class="comment-form">
					<% if user['login'] == True: %>
						<form action="./{{id}}" method="POST" target="_self" id="comment-form-inner" class="comment-form-inner">
							<label for="input">Leave a comment:</label><br />
							<textarea form="comment-form-inner" id="input" name="input"></textarea><br />
							
							<input type="hidden" id="type" name="type" value="comment" />
							<input type="submit" id="submit" name="submit" value="Submit" />
						</form> 
					<% else: %>
						<p>Log in or register to post a comment.</p>
					<% end %>
				</div>
				
				<ul>
					<% for k, v in comments.items(): %>
						<li>
							<span class="date">{{datetime.utcfromtimestamp(v['created']).strftime('%Y-%m-%d %H:%M:%S')}} UTC</span> 
							<span class="author">{{v['author']}}</span> 
							<span class="message">{{v['content']}}</span>
							<% if (user['name'] == v['author']) or user['admin']: %>
								<span class="decomment"><a href="?decomment={{k}}" target="_self">Delete</a></span>
							<% end %>
						</li>
					<% end %>
				</ul>
				
				<div class="pages">
					<ul>
						<%
							if pages > 1:
								for x in range(pages):
						%>
									<li><a href="?page={{x}}" target="_self">{{x}}</a></li>
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

		<script type="text/javascript" src="../static/marked/marked.min.js"></script>
		<script type="text/javascript">
			window.onload = function() {
				document.getElementById('content').innerHTML = marked(document.getElementById('markdown').innerHTML);
				document.getElementById('markdown').remove();
			}
		</script>
		
		<script type="text/javascript" src="../static/shared_document.js"></script>
		<script type="text/javascript" src="../static/jdenticon/dist/jdenticon.min.js"></script>
	</body>
</html>
