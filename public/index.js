$dom.onready(function(){
	createTweetButton();
	makeOkButtonAnimated();
});

function makeOkButtonAnimated() {
	var ok = $dom.get('#ok input')[0];

	ok.onmouseover = function(e) {
		$dom.style(ok, 'background-color', 'rgb(90, 90, 90)');
	};

	ok.onmouseout = function(e) {
		$dom.style(ok, 'background-color', 'grey');
	};
}