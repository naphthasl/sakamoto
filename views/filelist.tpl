<%
from datetime import datetime
import os

def sizeof_fmt(num, suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f %s%s" % (num, unit, suffix)
        end
        num /= 1024.0
    end
    return "%.1f %s%s" % (num, 'Yi', suffix)
end

%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>files</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		 <form action="./files" method="POST" enctype="multipart/form-data" id="fileupload" class="fileupload">
			<input type="file" id="fileselect" name="fileselect" />

			<input type="submit" id="submit" name="submit" value="Upload" />
		</form> 
		
		 <table class="files">
			<tr>
				<th>File ID</th>
				<th>File Address</th>
				<th>Original Filename</th>
				<th>File Size</th>
				<th>File Upload Date</th>
				<th>Actions</th>
			</tr>
			<% for k, v in filelist.items(): %>
				<tr>
					<td>{{k}}</td>
					<td><a class="filelink" href="./files/{{k}}" target="_top">unset</a></td>
					<td>{{v['original']}}</td>
					<td>{{sizeof_fmt(v['length'])}}</td>
					<td>{{datetime.utcfromtimestamp(v['created']).strftime('%Y-%m-%d %H:%M:%S')}} UTC</td>
					<td style="text-align: center;">
						<a href="./files?action=delete&amp;id={{k}}" class="fileaction"><span class="icon icon-cross"></span></a>
					</td>
				</tr>
			<% end %>
		 </table>
		 
		 <script type="text/javascript">
			 document.querySelectorAll('.filelink').forEach(function(node) {
				 node.innerHTML = node.href;
			 });
		 </script>
		 
		 <script type="text/javascript" src="./static/shared_document.js"></script>
	</body>
</html>
