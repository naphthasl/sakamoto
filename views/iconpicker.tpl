<%
import base64
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>pick an icon</title>
		
        <link rel="stylesheet" href="../static/main.css" />
		<link rel="stylesheet" href="../static/iconpicker.css" />
	</head>
	<body>
		 <form action="./do" method="POST" id="iconpicker" class="action">
			<input type="hidden" id="input" name="input" value="{{default}}" />
			<input type="hidden" id="id" name="id" value="{{dobject}}" />
			<input type="hidden" id="type" name="type" value="chicon" />
			
            <div class="picker">
                <div class="header">Changing icon for <b>{{name}}</b></div>
                <div class="icons">
                    <%
                        for k, v in sorted(list(icons.items()), key = (lambda x: x[0])):
                    %>
                            <a class="picon" href="#" data-location="{{k}}" onclick="document.getElementById('input').value = this.getAttribute('data-location'); updateSelection();">
                                <img style="image-rendering: crisp-edges;" src="{{v}}" width="32px" height="32px"></img>
                            </a>
                    <%
                        end
                    %>
                </div>
                <div class="footer">
                    <input type="submit" id="submit" name="submit" value="Change Icon" /> (Current selection: <span id="selection-text" style="font-weight: bold;"></span>)
                    <input type="text" id="search" name="search" placeholder="Search for an icon..." style="float: right;" onchange="updateSearch();" onkeyup="this.onchange();" onpaste="this.onchange();" oninput="this.onchange();" />
                </div>
            </div>
		</form>
		
        <script type="text/javascript">
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

            function updateSelection() {
                document.querySelectorAll('.picker .icons a').forEach(function(node) {
                    if (node.getAttribute('data-location') == document.getElementById('input').value) {
                        node.classList.add('selected');

                        document.getElementById('selection-text').innerHTML = node.getAttribute('data-location');
                    } else {
                        node.className = 'picon';
                    }
                });
            }

            function updateSearch() {
                document.querySelectorAll('.picker .icons a').forEach(function(node) {
                    if (node.getAttribute('data-location').toLowerCase().includes(document.getElementById('search').value.trim().toLowerCase())) {
                        node.style.display = 'inline-block';
                    } else {
                        node.style.display = 'none';
                    }
                });
            }

            window.addEventListener('load', function() {
                updateSelection();
                updateSearch();

                document.querySelector('.picker .icons .picon.selected').scrollIntoView();
            }, false);
        </script>
		<script type="text/javascript" src="../static/shared_document.js"></script>
	</body>
</html>
