$(document).ready(function(){
	createTweetButton();
	createOkHighlight();
	setupSearch();
});

function createOkHighlight() {
	var ok = $('#ok input');
	
	ok.bind('mouseover', highlight)
		.bind('mouseout', downplay);

	function highlight() {
		ok.css('background-color', 'rgb(80, 80, 80)');
	}

	function downplay() {
		ok.css('background-color', 'gray');
	}
}

function setupSearch() {
	$('#edit').bind('click', openSearch);
	$('p#close a').bind('click', closeSearch);
	$('#email_to_search').bind('keydown', doSearch);
}

function openSearch() {
	var input = $('#email_to_search').val('');
	$('#overlay').removeClass('invisible');
	input.get(0).focus();
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
	$.post('/search', {'email': email}, handleSearchResponse, 'json')
}

function handleSearchResponse(r) {
	r ? populateFormToEdit(r) : showError();
}

function populateFormToEdit(response) {
	$('#form input[name="name"]').val(response.name);
	$('#form input[name="email"]').val(response.email);
	
	(response.friends.length).times(function(i) {
		$('#form input[name="friends['+i+']"]').val(response.friends[i]);
	});
	
	$('#form').append('<input type="hidden" name="_method" value="put" />');
	$('#form input[name="email"]').attr('readonly', 'readonly');
	
	closeSearch();
	$('#form input[name="name"]').get(0).focus();
}

function showError() {
	$('#overlay span.error').removeClass('invisible');
}

function hideError() {
	$('#overlay span.error').addClass('invisible');
}
