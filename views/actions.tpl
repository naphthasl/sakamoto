<%
def str_trunc(data: str, maxlen: int = 24):
	return (data[:maxlen] + '...') if len(data) > maxlen else data
end
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>actions</title>
		
		<link rel="stylesheet" href="../static/main.css" />
		
		<% if rldmenu == True: %>
			<script type="text/javascript">
				parent.frames['menu'].location.reload();
			</script>
		<% end %>
	</head>
	<body>
		<table class="layout">
			<tr>
				<td>
					<div class="actions">
						<ul>
							<li class="listhead">Actions for {{str_trunc(pageprops['name'])}} <code>{{dobject}}</code></li>
							<li><a href="../action/{{dobject}}?type=child" target="menu"                >New child</a></li>
							<li><a href="../action/{{dobject}}?type=edit"                               >Edit</a></li>
							<li><a href="../document/{{dobject}}"                                       >View</a></li>
							<% if dobject != -1: %>
							<li><a href="../action/{{dobject}}?type=rename"                             >Rename</a></li>
							<li><a href="../action/{{dobject}}?type=chicon"                             >Change Icon</a></li>
							<li><a href="../action/{{dobject}}?type=delete"                             >Delete</a></li>
							<li><a href="../action/{{dobject}}?type=move&amp;direction=-1" target="menu">Move Up</a></li>
							<li><a href="../action/{{dobject}}?type=move&amp;direction=1" target="menu" >Move Down</a></li>
							<li><a href="../action/{{dobject}}?type=parent"                             >New Parent</a></li>
							<li><a href="../action/{{dobject}}?type=disabled"                           >Toggle Disabled <input class="led" type="checkbox" {{'checked' if pageprops['disabled'] else ''}} disabled> </a></li>
							<li><a href="../action/{{dobject}}?type=index"                              >Toggle Collapsed<input class="led" type="checkbox" {{'checked' if pageprops['index'   ] else ''}} disabled> </a></li>
							<li><a href="../action/{{dobject}}?type=hidden"                             >Toggle Hidden   <input class="led" type="checkbox" {{'checked' if pageprops['hidden'  ] else ''}} disabled> </a></li>
							<li><a href="../action/{{dobject}}?type=etarget"                            >Toggle Target   <input class="led" type="checkbox" {{'checked' if pageprops['etarget' ] else ''}} disabled> </a></li>
							<% end %>
						</ul>
					</div>
				</td>
					
				<td id="tiptd">
					<div class="tip">
						<p>{{!tip}}</p>
					</div>
				</td>
			</tr>
		</table>
		
		<script type="text/javascript" src="../static/shared_document.js"></script>
	</body>
</html>
