<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>rename</title>
		
		<link rel="stylesheet" href="../static/main.css" />
	</head>
	<body>
		<form action="./{{'password' if type == 'password' else 'do'}}" method="POST" id="rename" class="action">
			<table>
				<tr>
					<th class="tablehead" colspan="2">Rename</th>
				</tr>
				<tr>
					<td><label for="input">{{hint}}</label></td>
					<td><input type="{{'password' if type == 'password' else 'text'}}" id="input" name="input" value="{{default}}" /></td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;"><input type="submit" id="submit" name="submit" value="Submit" /></td>
				</tr>
			</table>

			<input type="hidden" id="id" name="id" value="{{dobject}}" />
			<input type="hidden" id="type" name="type" value="{{type}}" />
		</form>
		
		<script type="text/javascript" src="../static/shared_document.js"></script>
	</body>
</html>
