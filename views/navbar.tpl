<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>navbar</title>
		
		<link rel="stylesheet" href="./static/navbar.css" />
		<link rel="stylesheet" href="./static/main.css" />
		<base target="content" />
	</head>
	<body>
		<div class="width-restrictor">
			<div class="sakamoto"></div>
			
			<div class="bar-bottom"></div>
			<div class="bar-bottom-breadcrumb">
				<ul id="breadcrumb-menu"></ul>
			</div>
			
			<div class="bar-user">
				<div class="u-corner">
					<div class="u-corner-inner">
						<div class="u-corner-text">
							<% if user['login']: %>
								Logged in as <b>{{user['name']}}</b>
							<% else: %>
								Not logged in.
							<% end %>
						</div>
					</div>
				</div>
				
				<div class="user-buttons">
					<% if user['login']: %>
						<a href="./password">settings</a>
						<a href="./logout" class="logout-button">log out</a>
					<% else: %>
						<a href="./register">register</a>
						<a href="./login" class="login-button">log in</a>
					<% end %>
				</div>
			</div>
			
			<!--<div class="line-continuation"></div>-->
		</div>
		
		<script type="text/javascript" src="./static/shared_document.js"></script>
	</body>
</html>
