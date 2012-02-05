$(document).ready(function(){
	createTweetButton();
	
	var model = createModel();
	var view = createView();
	
	indexController(model, view).takeControl();
});

function createModel() {
	var model = {};
	
	model.getSearch = function(callback) {
		$.get('/search', callback);
	};
	
	model.postSearch = function(email, success, fail) {
		if(!email) return;
		
		$.post('/search', {'email': email}, after, 'json');
		
		function after(response) {
			response ? success(response) : fail();
		}
	};
	
	return model;
}

function indexController(model, view) {
	var controller = {};
	
	controller.takeControl = function() {
		bindEvents();
	}
	
	function bindEvents() {
		view.editLink().bind('click', getSearch);
		animate(view.okButton(), '#505050');
		animate(view.deleteButton(), '#A02020');
	}
	
	function getSearch() {
		model.getSearch(function(response) {
			view.showSearch(response);
			searchController(model, view).takeControl();
		});
	}
	
	return controller;
}

function searchController(model, view) {
	var controller = {};
	
	controller.takeControl = function() {
		view.resetSearch();
		bindEvents();
	}
	
	function bindEvents() {
		view.searchButton().bind('click', postSearch);
		view.closeButton().bind('click', view.closeSearch);
		view.deleteButton().bind('click', view.makeItDelete);
		view.searchField().bind('keydown', function(e) {
			(e && e.which === 13) && (postSearch());
		});
		animate(view.searchButton(), '#505050');
		animate(view.closeButton(), '#A02020');
	}
	
	function postSearch() {
		var email = view.searchField().attr('value');
		model.postSearch(email, view.populateForm, view.showError);
	}
	
	return controller;
}

function createView() {
	var view = {};
	var dom = {
		overlay: function() { return $('#overlay'); },
		okButton: function() { return $('#ok'); },
		editLink: function() { return $('#edit'); },
		searchButton: function() { return $('#go'); },
		closeButton: function() { return $('#close'); },
		searchField: function() {	return $('#search'); },
		deleteButton: function() {	return $('#delete'); },
		errorMessage: function() { return $('#overlay span.error'); },
		nameField: function() { return $('#form input[name="name"]'); },
		emailField: function() { return $('#form input[name="email"]'); },
		friendField: function(i) { return $('#form input[name="friends['+i+']"]'); },
		methodField: function() { return $('#form input[name="_method"]'); }
	};
	
	view.showSearch = function(data) {
	  dom.overlay().html(data);
	};
	
	view.resetSearch = function() {
		dom.errorMessage().addClass('invisible');
		dom.searchField().val('');
		dom.overlay().removeClass('invisible');
		dom.searchField().get(0).focus();
	};
	
	view.closeSearch = function() {
		dom.overlay().addClass('invisible');
	};
	
	view.populateForm = function(data) {
		dom.nameField().val(data.name);
		dom.emailField().val(data.email);
		dom.emailField().attr('readonly', 'readonly');
		(data.friends.length).times(function(i) {
			dom.friendField(i).val(data.friends[i]);
		});
		dom.methodField().attr('value', 'put');
		dom.deleteButton().removeClass('invisible');
		view.closeSearch();
		dom.nameField().get(0).focus();
	};
	
	view.showError = function() {
		dom.errorMessage().removeClass('invisible');
	};
	
	view.makeItDelete = function() {
		dom.methodField().attr('value', 'delete');
		dom.okButton().get(0).click();
	};
	
	view.okButton = dom.okButton;
	view.editLink = dom.editLink;
	view.searchButton = dom.searchButton;
	view.closeButton = dom.closeButton;
	view.searchField = dom.searchField;
	view.deleteButton = dom.deleteButton;
	return view;
}
