<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>users</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		 <table class="files">
			<tr class="tablehead" style="text-align: left;">
				<th>User Name</th>
				<th>Administrator</th>
				<th>Actions</th>
			</tr>
			<% for v in ulist: %>
				<tr>
                    <td>{{v['name']}}</td>
                    <td><input class="led" type="checkbox" style="float: left;" {{'checked' if v['admin'] else ''}} disabled></td>
                    <td>
                        <% if cuser['name'] != v['name']: %>
                            <a href="?action=delete&amp;id={{v['name']}}" class="icon icon-cross"></a>
                            <a href="?action=admin&amp;id={{v['name']}}" class="icon icon-cmd"></a>
                        <% end %>
                    </td>
				</tr>
			<% end %>
		 </table>
		 <script type="text/javascript" src="./static/shared_document.js"></script>
	</body>
</html>
