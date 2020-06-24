<%
import html

def chunks(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]
    end
end
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		
		<title>search</title>
		
		<link rel="stylesheet" href="./static/main.css" />
	</head>
	<body>
		<h1>Case Insensitive Search</h1>
        <p>{{len(squery)}} page hits for search query <b>{{iquery}}</b></p>

        <% for k, v in squery.items(): %>
            <h2><a href="./document/{{k}}">{{v['name']}}</a></h2>

            <p>Query appears {{v['haystack'].count(iquery)}} times.</p>

            <ul>
                <%
                    for x in chunks(v['haystack'], 192):
                        if iquery in x:
                            y = ('<b>{0}</b>'.format(iquery)).join(map(html.escape, x.split(iquery)))

                            %>
                                <li>{{!y}}</li>
                            <%
                        end
                    end
                %>
            </ul>
        <% end %>

		% include('shared_js.tpl', navback = './')
	</body>
</html>
