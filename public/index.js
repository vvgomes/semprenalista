$(document).ready(function(){
	createTweetButton();
	highlightButtons();
	setupSearch();
});

function highlightButtons() {	
	highlightButton($('#ok'), '#505050', '#808080');
	highlightButton($('#delete'), '#A02020', '#A06060');
	
	function highlightButton(e, h, d) {
		e.bind('mouseover', highlight);
		e.bind('mouseout', downplay);

		function highlight() {
			e.css('background-color', h);
		}

		function downplay() {
			e.css('background-color', d);
		}
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
	
	setupDeleteButton();
	
	closeSearch();
	$('#form input[name="name"]').get(0).focus();
}

function showError() {
	$('#overlay span.error').removeClass('invisible');
}

function hideError() {
	$('#overlay span.error').addClass('invisible');
}

function setupDeleteButton() {
	$('#delete').removeClass('invisible');
	$('#delete').bind('click', function() {
		$('#form input[name="_method"]').attr('value', 'delete');
		$('#ok').get(0).click();
	});
}