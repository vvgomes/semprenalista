$(document).ready(function(){
	createTweetButton();
	makeOkButtonAnimated();
	setupSearch();
});

function makeOkButtonAnimated() {
	var ok = $('#ok input');
	
	ok.bind('mouseover', highlight)
		.bind('mouseout', downplay);

	function highlight() {
		ok.css('background-color', 'rgb(90, 90, 90)');
	};

	function downplay() {
		ok.css('background-color', 'grey');
	};
}

function setupSearch() {
	$('#edit').bind('click', openSearch);
	$('p#close a').bind('click', closeSearch);
	$('#email_to_search').bind('keydown', doSearch);
}

function openSearch() {
	overlay('visible');
	$('#email_to_search').attr('value', '').focus();
}

function closeSearch() {
	overlay('hidden');
}

function doSearch(event) {
	if(event && event.keyCode != '13') return;
	var email = $('#email_to_search').attr('value');
	(email.trim().length > 0) && (sendRequest(email));
}

function sendRequest(email) {
	alert('sending request for email: '+email)
}

function overlay(visibility) {
	$('#overlay').css('visibility', visibility);
}