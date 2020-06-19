<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>menu</title>
		
		<link rel="stylesheet" href="./static/menu.css" />
		<link rel="stylesheet" href="./static/main.css" />
		<base target="content" />
	</head>
	<body>
		<% if user['admin'] == True: %>
			<div class="actionmenu sect">
				<h3>Site Management</h3>
				<div class="sect-content">
					<ul class="sect-default-ul">
						<li><a href="./actions/-1">Root Actions</a></li>
						<li><a href="./options"   >Site-Wide Options</a></li>
						<li><a href="./files"     >Manage Static Files</a></li>
						<li><a href="./credits"   >Credits</a></li>
					</ul>
				</div>
			</div>
		<% end %>
		
		<div class="menu sect">
			<h3>Site Index</h3>
			<div class="sect-content">
				<div class="menu-index">
					{{!content}}
				</div>
			</div>
		</div>
		
		<script type="text/javascript">
			function toggleLPHidden(x) {
				if (x.style.display === "none") {
					x.style.display = "block";
				} else {
					x.style.display = "none";
				}
			}
			
			function toggleExpandClass(x) {
				document.querySelectorAll('.menu-index li').forEach(function(node) {
					recomputeCoverupHeights(node);
				});
				
				x.classList.toggle('tree-hidden');
			}
			
			function recomputeCoverupHeights(node) {
				if (node.querySelectorAll('ul').length > 0) {
					var last_element;
					node.querySelectorAll('ul > li').forEach(function(subnode) {
						if (subnode.parentNode == node.querySelector('ul')) {
							last_element = subnode;
						}
					});
					
					var coverup = node.querySelector('ul').querySelector('.tree-mids-coverup');
					var llheight = (last_element.clientHeight - 16);
					if (llheight < 0) {
						llheight = 0;
					}
					
					coverup.style.height = '100%';
					coverup.style.height = (coverup.clientHeight - llheight) + 'px';
				}
			}
			
			document.querySelectorAll('.menu-index .ul-root li').forEach(function x(node) {
				if (node.querySelectorAll('ul').length > 0) {
					node.innerHTML = '<a class="tree-collapse" href="#" target="_self" onclick="toggleLPHidden(this.parentNode.querySelector(\'ul\')); toggleExpandClass(this);"></a>' + node.innerHTML;
					
					var cul = node.querySelector('ul');
					cul.innerHTML = '<div class="tree-mids-coverup"><div class="tree-mids"></div><div class="tree-mids-final"></div></div>' + cul.innerHTML;
					
					recomputeCoverupHeights(node);
				} else {
					node.innerHTML = '<span class="tree-passthrough"></span>' + node.innerHTML;
				}
				
				node.querySelectorAll('ul > li').forEach(x);
				
				var lies = node.querySelectorAll('ul > li');
				lies.forEach(function(subnode, index) {
					subnode.innerHTML = '<span class="tree-mid"></span>' + subnode.innerHTML;
				});
			});
			
			document.querySelectorAll('.menu-index .tree-pre-collapsed .tree-collapse').forEach(function(node) {
				node.click();
			});
		</script>
		<script type="text/javascript" src="./static/shared_document.js"></script>
	</body>
</html>
