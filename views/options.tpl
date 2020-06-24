<%
import json, string, random

type_conversions = {
	str: 'text',
	int: 'number',
	float: 'number',
	bool: 'checkbox'
}
%>
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
				<tr class="tablehead">
					<th colspan="2">Side-Wide Options</th>
				</tr>
				<% for k, v in items.items(): %>
					<%
						jkey = json.dumps(k)
						jvalue = json.dumps(v)
						jtype = type(v)
						jid = ''.join([str(random.choice(string.hexdigits)) for _ in range(6)])

						inputtype = type_conversions[jtype]
					%>
					<tr>
						<td><label for="{{jid}}">{{k}}</label></td>
						<td>
							<input type="hidden" id="{{jid}}" name="{{jkey}}" value="{{jvalue}}" />

							<% if jtype in [str, int, float]: %>
								<input type="{{inputtype}}" oninput="document.getElementById('{{jid}}').value = JSON.stringify(this.value);" value="{{v}}" />
							<% elif jtype == bool: %>
								<input type="{{inputtype}}" onchange="document.getElementById('{{jid}}').value = JSON.stringify(this.checked);"{{' checked' if v == True else ''}}></input>
							<% else: %>
								<script type="text/javascript">
									document.getElementById('{{jid}}').type = 'text';
								</script>
							<% end %>
						</td>
					</tr>
				<% end %>
				<tr>
					<td colspan="2" style="text-align: center;"><input type="submit" value="Change Options" /></td>
				</tr>
			</table>
		</form>
		
		% include('shared_js.tpl', navback = './')
	</body>
</html>
