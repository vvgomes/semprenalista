$(document).ready(function(){
	createTweetButton();
	$('li#home').toggleClass('active');

	$('#search-box').on('shown', resetSearchBox);
	$('#search-button').bind('click', search);
	$('#search-email').bind('keydown', checkKeyBeforeSearch);
	$('#delete-yes').bind('click', performDelete);
});

function search() {
	var email = $('#search-email').val();
	var afterSearch = function(data) {
		data ? populateFormToEdit(data) : showNotFoundAlert();
	}; 
	getSearch(email, afterSearch);
}

function getSearch(email, callback) {
	$.get('/search', {email: email}, callback);
}

function showNotFoundAlert() {
	$('#search-alert').removeClass('invisible');
}

function populateFormToEdit(data) {
	$('#main-form input[name="name"]').val(data.name);
	$('#main-form input[name="email"]').val(data.email);
	$('#main-form input[name="email"]').attr('readonly', 'readonly');
	(data.friends.length).times(function(i) {
		$('#main-form input[name="friends['+i+']"]').val(data.friends[i]);
	});
	$('#main-form input[name="_method"]').attr('value', 'put');
	$('#delete').removeClass('invisible');
	$('#search-box').modal('hide');
	$('#flash').alert('close');
	$('#main-form input[name="name"]').get(0).focus();
}

function performDelete() {
	$('#delete-box').modal('hide');
	$('#main-form input[name="_method"]').attr('value', 'delete');
	$('#submit').click();
}

function resetSearchBox() {
		$('#search-email').val('');
		$('#search-alert').addClass('invisible');
	}

function checkKeyBeforeSearch(event) {
	if(event.which != 13) return; 
	search();
}
	