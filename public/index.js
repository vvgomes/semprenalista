$dom.onready(function(){
	createTweetButton();
	makeOkButtonAnimated();
	setupEmailSearch();
});

function makeOkButtonAnimated() {
	var ok = $dom.get('#ok input')[0];

	ok.onmouseover = function(event) {
		$dom.style(ok, 'background-color', 'rgb(90, 90, 90)');
	};

	ok.onmouseout = function(event) {
		$dom.style(ok, 'background-color', 'grey');
	};
}

function setupEmailSearch() {
	var edit = $dom.get('#edit')[0];
	edit.onclick = openEmailSearch;
	
	var close = $dom.get('p#close a')[0];
	close.onclick = closeEmailSearch;
}

function openEmailSearch() {
	overlay('visible');
	var email = $dom.get('#email_to_search')[0];
	email.value = '';	
	email.onkeydown = search;
	email.focus();
}

function closeEmailSearch() {
	overlay('hidden');
}

function search(event) {
	if(event && event.keyCode != '13') return;
	
	var email = $dom.get('#email_to_search')[0].value;
	(email.trim().length > 0) && (window.location='/');
}

function overlay(visibility) {
	var overlay = $dom.get('#overlay')[0];
	$dom.style(overlay, 'visibility', visibility);
}