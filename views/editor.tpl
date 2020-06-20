<%
import json
try:
	content = json.loads(content)
except:
	content = default_content
end
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>rename</title>
		
		<link rel="stylesheet" href="../static/main.css" />
		<link rel="stylesheet" href="../static/simplemde/dist/simplemde.min.css" />
	</head>
	<body>
		 <form action="./do" method="POST" id="editor" class="editor">
			<textarea form="editor" id="markdown" name="markdown">{{content['markdown']}}</textarea><br/>
			
			<label for="link">External Link:</label><br />
			<input type="text" id="link" name="link" value="{{content['link']}}" />
			<input type="checkbox" id="external" name="external" value="1" {{'checked' if content['external'] else ''}} /><br />
			
			<input type="hidden" id="id" name="id" value="{{dobject}}" />
			<input type="hidden" id="type" name="type" value="edit" />
			
			<input type="submit" id="submit" name="submit" value="Submit" />
		</form>
		
		<script type="text/javascript" src="../static/simplemde/dist/simplemde.min.js"></script>
		<script type="text/javascript">
			var simplemde = new SimpleMDE({ element: document.getElementById("markdown") });
		</script>
		
		<script type="text/javascript" src="../static/shared_document.js"></script>
	</body>
</html>
