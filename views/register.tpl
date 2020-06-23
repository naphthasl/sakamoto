<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>register</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		<form action="./register" method="POST" id="register" class="register">
		 	<table>
		 		<tr class="tablehead">
					<th colspan="3">Register</th>
				</tr>
				<tr>
					<td><label for="username">Username</label></td>
					<td><input type="text" id="username" name="username" /></td>
					<td>Usernames must be under 24 characters long and above 4 characters. They must only contain lowercase ASCII characters, digits and the special characters <code>_-@!?./+</code>. They must not contain a whitespace.</td>
				</tr>
				<tr>
					<td><label for="password">Password</label></td>
					<td><input type="password" id="password" name="password" /></td>
					<td>Your password must be under 128 characters and above 4 characters. It is case sensitive, and will be stored using BCrypt with a default work factor of 12.</td>
				</tr>
				<tr>
					<td><label for="password">Confirm Password</label></td>
					<td><input type="password" id="password2" name="password2" /></td>
					<td>Type your password again, both to help you remember it and to ensure that you have typed it correctly.</td>
				</td>
				<tr>
					<td><label for="captcha">Human Validation</label></td>
					<td>
						<div class="captcha">
							<img src="./captcha/{{captcha}}"></img><br />
							
							<input type="text" id="captcha" name="captcha" /><br />
							<input type="hidden" id="captchaid" name="captchaid" value="{{captcha}}" />
						</div>
					</td>
					<td>Type out the text shown on the left. This helps prevent automated submissions. As these images are automatically generated, there is a chance for them to potentially be unreadable for humans too. In the event that this happens, you can reload the page to get a new one.</td>
				</tr>
				<tr>
					<td colspan="3" style="text-align: center;"><input type="submit" id="submit" name="submit" value="Submit" /></td>
				</tr>
			</table>
		</form> 

		<br />
		
		<div class="tip">
			<p>{{!tip}}</p>
		</div>
		
		<script type="text/javascript" src="./static/shared_document.js"></script>
	</body>
</html>
