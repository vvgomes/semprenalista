function animate(element, highlightColor) {	
	var defaultColor = element.css('background-color');
	
	function highlight() {
		element.css('background-color', highlightColor);
	}
		
	function downplay() {
		element.css('background-color', defaultColor);
	}
	
	(function bindEvents() {
		element.bind('mouseover', highlight);
		element.bind('mouseout', downplay);
	})();
}

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