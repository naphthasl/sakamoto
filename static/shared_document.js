/* Fucking framesets and iframes, always creating complications like this... */
function dirname(path) {
	return path.substr(0, path.lastIndexOf("/"));
}

if ( top === self ) {
	e = localStorage.getItem("root");
	if (e == null) {
		root = dirname(dirname(document.currentScript.src));
	} else {
		root = e;
	}
	window.location.href = root+'?ref='+window.location.href;
}

if (document.title == 'menu' || document.title == 'navbar') {
	e = window.location.href;
	localStorage.setItem("root", dirname(e));
}
