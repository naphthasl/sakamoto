% import json
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>options</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		<form action="./options" method="POST" id="options" class="options">
			<table>
				<% for k, v in items.items(): %>
					<tr>
						<td><label for="{{json.dumps(k)}}">{{json.dumps(k)}}</label></td>
						<td><input type="text" id="{{json.dumps(k)}}" name="{{json.dumps(k)}}" value="{{json.dumps(v)}}" /></td>
					</tr>
				<% end %>
				<tr>
					<td colspan="2" style="text-align: center;"><input type="submit" id="submit" name="submit" value="Change Options" /></td>
				</tr>
			</table>
		</form>
		
		<script type="text/javascript" src="./static/shared_document.js"></script>
	</body>
</html>
