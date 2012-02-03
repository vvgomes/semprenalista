$(document).ready(function(){
	createTweetButton();
	
	var model = createModel();
	var view = createView();
	
	indexController(model, view).takeControl();
});

function createModel() {
	var model = {};
	
	model.getSearch = function(callback) {
		$.get('/search', after);
		
		function after(response) {
			callback(response);
		}
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

function createView() {
	var view = {};
	
	view.showSearch = function(data) {
	  $('#overlay').html(data);
	};
	
	view.resetSearch = function() {
		$('#overlay span.error').addClass('invisible');
		$('#search').val('');
		$('#overlay').removeClass('invisible');
		$('#search').get(0).focus();
	};
	
	view.closeSearch = function() {
		$('#overlay').addClass('invisible');
	};
	
	view.populateForm = function(data) {
		$('#form input[name="name"]').val(data.name);
		$('#form input[name="email"]').val(data.email);

		(data.friends.length).times(function(i) {
			$('#form input[name="friends['+i+']"]').val(data.friends[i]);
		});
		
		$('#form').append('<input type="hidden" name="_method" value="put" />');
		$('#form input[name="email"]').attr('readonly', 'readonly');
		$('#delete').removeClass('invisible');
		
		view.closeSearch();
		
		$('#form input[name="name"]').get(0).focus();
	};
	
	view.makeItDelete = function() {
		$('#form input[name="_method"]').attr('value', 'delete');
		$('#ok').get(0).click();
	};
	
	view.showError = function() {
		$('#overlay span.error').removeClass('invisible');
	};
	
	view.editLink = function() {
		return $('#edit');
	};
	
	view.okButton = function() {
		return $('#go');
	};
	
	view.closeButton = function() {
		return $('#close');
	};
	
	view.searchField = function() {
		return $('#search');
	};
	
	view.deleteButton = function() {
		return $('#delete');
	};
	
	return view;
}

function indexController(model, view) {
	var controller = {};
	
	controller.takeControl = function() {
		bindEvents();
	}
	
	function bindEvents() {
		view.editLink().bind('click', getSearch);
		animate($('#ok'), '#505050');
		animate($('#delete'), '#A02020');
	}
	
	function getSearch() {
		model.getSearch(function(r) {
			view.showSearch(r);
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
		view.okButton().bind('click', postSearch);
		view.closeButton().bind('click', view.closeSearch);
		view.deleteButton().bind('click', view.makeItDelete);
		view.searchField().bind('keydown', function(e) {
			(e && e.keyCode === 13) && (postSearch());
		});
		animate($('#go'), '#505050');
		animate($('#close'), '#A02020');
	}
	
	function postSearch() {
		var email = view.searchField().attr('value');
		model.postSearch(email, view.populateForm, view.showError);
	}
	
	return controller;
}