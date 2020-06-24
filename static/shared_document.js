/* Fucking framesets and iframes, always creating complications like this... */
function dirname(path) {
	return path.substr(0, path.lastIndexOf("/"));
}

window.addEventListener('load', function() {
	if ( top === self ) {
		e = localStorage.getItem("root");
		if (e == null) {
			root = dirname(dirname(document.currentScript.src));
		} else {
			root = e;
		}
		window.location.href = root+'?ref='+window.location.href;
	}

	/* Needed to resolve a bug in Bottle, I guess? */
	document.querySelectorAll('form[method="post"]').forEach(function(node) {
		node.enctype = 'multipart/form-data';
	});
}, false);

if (document.title == 'menu' || document.title == 'navbar') {
	e = window.location.href;
	localStorage.setItem("root", dirname(e));
} else {
	window.addEventListener('scroll', function() {
		localStorage.setItem("scroll", document.documentElement.scrollTop);
	}, false);

	window.addEventListener('load', function() {
		e = localStorage.getItem("scroll");

		if (e == null) {
			document.documentElement.scrollTop = 0;
		} else {
			document.documentElement.scrollTop = Number(e);
		}
	}, false);

	window.addEventListener('beforeunload', function() {
		if (document.activeElement.href == undefined || document.activeElement.href.split('?').shift() != window.location.href.split('?').shift()) {
			localStorage.setItem("scroll", 0);
		}		
	});
}