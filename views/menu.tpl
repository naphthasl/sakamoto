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
						<li><a href="./help"><span class="icon icon-book"></span> Help</a></li>
						<li><a href="./actions/-1"><span class="icon icon-home"></span> Root Actions</a></li>
						<li><a href="./options"><span class="icon icon-cog"></span> Site-Wide Options</a></li>
						<li><a href="./files"><span class="icon icon-folder"></span> Manage Static Files</a></li>
						<li><a href="./users"><span class="icon icon-edit-user"></span> Manage Users</a></li>
						<li><a href="#" onclick="window.parent.document.getElementById('content').contentWindow.location.reload(true);" target="_self"><span class="icon icon-refresh"></span> Reload Content Frame</a></li>
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

		<div style="width: 100%;" id="footer-spacer"></div>

		<div class="footer">
			<p>{{options['copyright_message']}}</p>
			<p>This website is powered by <a href="https://github.com/naphthasl/sakamoto">Sakamoto</a>, a content management system created by <a href="https://lotte.link">LotteLink</a>.</p>
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
				x.classList.toggle('tree-hidden');
				
				document.querySelectorAll('.menu-index li').forEach(function(node) {
					recomputeCoverupHeights(node);
					
					node.querySelectorAll('.tree-hidden').forEach(function(subnode) {
						subnode.parentNode.classList.add("nodown");
					});
				});
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
					
					node.querySelector('.menutext').classList.remove("nodown");
				} else {
					node.querySelector('.menutext').classList.add("nodown");
				}
			}
			
			document.querySelectorAll('.menu-index .ul-root li').forEach(function x(node) {
				if (node.querySelectorAll('ul').length > 0) {
					node.querySelector('.menutext').innerHTML = '<a class="tree-collapse" href="#" target="_self" onclick="toggleLPHidden(this.parentNode.parentNode.querySelector(\'ul\')); toggleExpandClass(this);"></a>' + node.querySelector('.menutext').innerHTML;
					
					var cul = node.querySelector('ul');
					cul.innerHTML = '<div class="tree-mids-coverup"><div class="tree-mids"></div><div class="tree-mids-final"></div></div>' + cul.innerHTML;
					
					recomputeCoverupHeights(node);
				} else {
					node.querySelector('.menutext').innerHTML = '<span class="tree-passthrough"></span>' + node.querySelector('.menutext').innerHTML;
					
					recomputeCoverupHeights(node);
				}
				
				node.querySelectorAll('ul > li').forEach(x);
				
				var lies = node.querySelectorAll('ul > li');
				lies.forEach(function(subnode, index) {
					if (!subnode.querySelector('.menutext').innerHTML.includes('tree-mid')) {
						subnode.querySelector('.menutext').innerHTML = '<span class="tree-mid"></span>' + subnode.querySelector('.menutext').innerHTML;
					}
				});
			});
			
			document.querySelectorAll('.menu-index .tree-pre-collapsed .tree-collapse').forEach(function(node) {
				node.click();
			});

			document.querySelectorAll('.menu-index ul li .menutext').forEach(function(node) {
				node.addEventListener("mouseover", function() {
					this.parentNode.getElementsByClassName('adminopt')[0].style.display = 'block';
				});

				node.addEventListener("mouseout", function() {
					this.parentNode.getElementsByClassName('adminopt')[0].style.display = 'none';
				});
			});

			document.getElementById('footer-spacer').style.height = document.getElementsByClassName('footer')[0].scrollHeight + 'px';
		</script>
		% include('shared_js.tpl', navback = './')
	</body>
</html>
