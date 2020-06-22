<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>login</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		 <form action="./login" method="POST" id="login" class="login">
			<table>
				<tr>
					<td><label for="username">Username</label></td>
					<td><input type="text" id="username" name="username" /></td>
				</tr>
				<tr>
					<td><label for="password">Password</label></td>
					<td><input type="password" id="password" name="password" /></td>
				</tr>
				<tr>
					<td><label for="captcha">What are the numbers above?</label></td>
					<td>
						<div class="captcha">
							<img src="./captcha/{{captcha}}"></img><br />
							
							<input type="text" id="captcha" name="captcha" /><br />
							<input type="hidden" id="captchaid" name="captchaid" value="{{captcha}}" />
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;">
						<input type="submit" id="submit" name="submit" value="Submit" />
					</td>
				</tr>
			</table>
		</form>
		
		<script type="text/javascript" src="./static/shared_document.js"></script> 
	</body>
</html>
