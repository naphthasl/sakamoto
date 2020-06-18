<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-GB">
	<head>
		<title>{{title}}</title>

		<meta name="description" content="Sakamoto Content Management System" />
		<meta name="author"      content="Naphtha Nepanthez" />
		
		<script type="text/javascript"><!--//--><![CDATA[//><!--
			function getParameterByName(name, url) {
				if (!url) url = window.location.href;
				name = name.replace(/[\[\]]/g, '\\$&');
				var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
					results = regex.exec(url);
				if (!results) return null;
				if (!results[2]) return '';
				return decodeURIComponent(results[2].replace(/\+/g, ' '));
			}
			
			if (!String.prototype.includes) {
				String.prototype.includes = function(search, start) {
					'use strict';
					if (typeof start !== 'number') {
						start = 0;
					}

					if (start + search.length > this.length) {
						return false;
					} else {
						return this.indexOf(search, start) !== -1;
					}
				};
			}
			
			function menuLinkCheck() {
				document.getElementById('menu').contentDocument.querySelectorAll('a').forEach(function(node) {
					if (!node.className.split(' ').includes('auto')) {
						if (node.href == document.getElementById('content').contentWindow.location.href) {
							node.style.fontWeight = 'bold';
						} else {
							node.style.fontWeight = 'normal';
						}
					}
				});
			}
			
			window.onload = function() {
				var content = document.getElementById('content');
				var navbar  = document.getElementById('navbar');
				var menu    = document.getElementById('menu');
				
				content.onload = function() {
					menuLinkCheck();
					
					var location = content.contentWindow.location.href;
					
					if (location.includes('document')) {
						if (history.pushState) {
							history.pushState({}, null, '?doc=' + location.split('/').pop());
						}
					} else {
						if (history.pushState) {
							history.pushState({}, null, './');
						}
					}
				}
				
				menuLinkCheck();
				
				menu.onload = function() {
					navbar.contentWindow.location.reload();
				}
			}
			
		//--><!]]></script>
	</head>
	<frameset rows="64px,*" border=0 frameborder=0 framespacing=0>
		<frame id="navbar" name="navbar" src="./navbar" noresize />
		<frameset cols="240px,740px,*" class="sep" border=0 frameborder=0 framespacing=0>
			<frame id="menu"    name="menu"    src="./menu" noresize />
			<frame id="content" name="content" src="{{content}}" noresize />
			<frame id="filler"  name="filler"  src="about:blank" noresize />
		</frameset>
		<noframes>
			<p>Your browser does not support framesets. Considering the current only alternative to framesets is an extremely buggy JavaScript library (wait, isn't that all JavaScript libraries?), you just won't be able to access this page.</p>
		</noframes>
	</frameset>
</html>
