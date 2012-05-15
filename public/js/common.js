function createTweetButton() {
	!function(d, s, id) {
	  var js, fjs = d.getElementsByTagName(s)[0];
	  if(!d.getElementById(id)){
	    js=d.createElement(s);
	    js.id=id;js.src="//platform.twitter.com/widgets.js";
	    fjs.parentNode.insertBefore(js,fjs);
	  }
	}(document, "script", "twitter-wjs");
}

function activateLink(page) {
	$('li#'+page).toggleClass('active');
}

function e(selector) {
	return function() { 
		return $(selector); 
	};
}

function when(key, callback) {
	return function(event) {
		if(event.which != key) return; 
		callback(event);
	};
}