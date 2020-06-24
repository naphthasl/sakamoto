function dirname(path) {
	return path.substr(0, path.lastIndexOf("/"));
}

function revisedRandId() {
	return Math.random().toString(36).replace(/[^a-z]+/g, '').substr(2, 10);
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
	
	/*
	document.querySelectorAll('form input[type="password"]').forEach(function(node) {
		var	visible_id = revisedRandId();
		
		var hidden = document.createElement('input');
		hidden.type = 'hidden';
		hidden.name = node.name; hidden.id = node.id;
		node.name = ''; node.id = visible_id;
		node.parentNode.appendChild(hidden);
		
		var recalc_func = function() {
			
		}
	});
	*/
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
