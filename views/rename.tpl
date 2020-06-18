<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>rename</title>
		
		<link rel="stylesheet" href="../static/main.css" />
	</head>
	<body>
		 <form action="./{{'password' if type == 'password' else 'do'}}" method="POST" id="rename" class="action">
			<label for="input">{{hint}}:</label><br />
			<input type="{{'password' if type == 'password' else 'text'}}" id="input" name="input" value="{{default}}" /><br />
			
			<input type="hidden" id="id" name="id" value="{{dobject}}" />
			<input type="hidden" id="type" name="type" value="{{type}}" />
			
			<input type="submit" id="submit" name="submit" value="Submit" />
		</form>
		
		<script type="text/javascript" src="../static/shared_document.js"></script>
	</body>
</html>
