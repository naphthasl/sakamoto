<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>login</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		 <form action="./login" method="POST" id="login" class="login">
			<label for="username">Username:</label><br />
			<input type="text" id="username" name="username" /><br />
			
			<label for="password">Password:</label><br />
			<input type="password" id="password" name="password" /><br />
			
			<div class="captcha">
				<img src="./captcha/{{captcha}}"></img><br />
				
				<label for="captcha">What are the numbers above?</label><br />
				<input type="text" id="captcha" name="captcha" /><br />
				<input type="hidden" id="captchaid" name="captchaid" value="{{captcha}}" />
			</div>
			
			<input type="submit" id="submit" name="submit" value="Submit" />
		</form>
		
		<script type="text/javascript" src="./static/shared_document.js"></script> 
	</body>
</html>
