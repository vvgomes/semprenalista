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
	var input = $('#email_to_search').get(0);
	input.value = '';
	$('#overlay').removeClass('invisible');
	input.focus();
}

function closeSearch() {
	$('#overlay').addClass('invisible');
}

function doSearch(event) {
	if(event && event.keyCode != '13') return;
	var email = $('#email_to_search').attr('value');
	(email.trim().length > 0) && (sendRequest(email));
}

function sendRequest(email) {
	$.post('/search', {'email': email}, handleResponse, 'json')
}

function handleResponse(r) {
	r ? closeSearch() : showError();
}

function showError() {
	$('#overlay span.error').removeClass('invisible');
}

function hideError() {
	$('#overlay span.error').addClass('invisible');
}