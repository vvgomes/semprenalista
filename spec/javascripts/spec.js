describe('highlight animation', function() {
	var html = '<input id="ok" type="button"/>';
	var darker = 'rgb(80, 80, 80)';
	var normal = 'rgb(128, 128, 128)';
	var animation, button;

	beforeEach(function() {
		$('body').append(html);
		button = $('#ok');
		button.css('background-color', normal);
		animate(button, darker);
	});

	afterEach(function() {
		button.remove();
	});
	
	it('should highlight the button on mouse over', function() {
		button.trigger('mouseover');
		expect(button.css('background-color')).toBe(darker);
	});

	it('should restore the button on mouse out', function() {
		button.trigger('mouseout');
		expect(button.css('background-color')).toBe(normal);
	});

});

describe('search model', function() {
	var model, view;
	
	beforeEach(function() {
		model = createModel();
	});
	
	describe('fetching the the search box', function() {
		
		it('should invoke the callback', function() {
			$.get = function(path, after){ after(); };
			view = {showSearch: function(){}};
			spyOn(view, 'showSearch');
			model.getSearch(view.showSearch);
			expect(view.showSearch).toHaveBeenCalled();
		});
		
	});
	
	describe('searching', function(){
		
		beforeEach(function() {
			view = {success: function(){}, fail: function(){}};
		});
		
		it('should invoke success callback when somebody is found', function() {
			makePostReturnResponse();
			spyOn(view, 'success');
			model.postSearch('tim@maia.com', view.success, view.fail);
			expect(view.success).toHaveBeenCalled();
		});
	
		it('should invoke fail callback when nobody is found', function() {
			makePostNotReturnResponse();
			spyOn(view, 'fail');
			model.postSearch('tim@maia.com', view.success, view.fail);
			expect(view.fail).toHaveBeenCalled();
		});
	
		it('should skip when no email is provided', function() {
			spyOn(view, 'success');
			spyOn(view, 'fail');
			model.postSearch('', view.success, view.fail);
			expect(view.success).not.toHaveBeenCalled();
			expect(view.fail).not.toHaveBeenCalled();
		});
		
		function makePostReturnResponse() {
			$.post = function(path, params, after, mime){ after('foo'); };
		}
		function makePostNotReturnResponse() {
			$.post = function(path, params, after, mime){ after(); };
		}
		
	});
});

describe('index controller', function() {
	var html = '<a id="edit" href="#"/>';
	var model, view, search, realSearch, realAnimate;
	
	beforeEach(function() {
		$('body').append(html);
		createStubs();
	});
	
	afterEach(function() {
		view.editLink().remove();
		restoreFunctions();
	});
	
	it('should render search when edit link is clicked', function() {
		spyOn(view, 'showSearch');
		indexController(model, view).takeControl();
		view.editLink().trigger('click');
		expect(view.showSearch).toHaveBeenCalled();
	});
	
	it('should give control to search controller after rendering search', function() {
		spyOn(search, 'takeControl');
		indexController(model, view).takeControl();
		view.editLink().trigger('click');
		expect(search.takeControl).toHaveBeenCalled();
	});
	
	function createStubs() {
		search = { takeControl: function(){} };
		model = { getSearch: function(c){ c(); } };
		view = {
			editLink: function(){ return $('#edit'); },
			okButton: function(){},
			deleteButton: function(){},
			showSearch: function(){} 
		};
		
		realSearch = searchController;
		searchController = function(){ return search; };
		
		realAnimate = animate;
		animate = function(){};
	}
	
	function restoreFunctions() {
		searchController = realSearch;
		animate = realAnimate;
	}
	
});

describe('search controller', function() {
	var html = 
		'<input type="search" id="search" value="foo"/>'+
    '<input type="button" id="go"/>'+
    '<input type="button" id="close"/>'+
		'<input type="button" id="delete"/>';
	var model, view, realAnimate;
	
	beforeEach(function() {
		$('body').append(html);
		createStubs();		
	});
	
	afterEach(function() {
		view.searchField().remove();
		view.searchButton().remove();
		view.closeButton().remove();
		view.deleteButton().remove();
		restoreFunctions();
	});
	
	it('should post search when search button is clicked', function() {
		spyOn(model, 'postSearch');
		searchController(model, view).takeControl();
		view.searchButton().trigger('click');
		expect(model.postSearch).toHaveBeenCalled();
	});
	
	it('should post search when the user press enter on search field', function() {
		spyOn(model, 'postSearch');
		searchController(model, view).takeControl();
		keyvent.on(view.searchField().get(0)).down(13);
		expect(model.postSearch).toHaveBeenCalled();
	});
	
	it('should close search box when close button is clicked', function() {
		spyOn(view, 'closeSearch');
		searchController(model, view).takeControl();
		view.closeButton().trigger('click');
		expect(view.closeSearch).toHaveBeenCalled();
	});
	
	it('should configure delete view when delete button is clicked', function() {
		spyOn(view, 'makeItDelete');
		searchController(model, view).takeControl();
		view.deleteButton().trigger('click');
		expect(view.makeItDelete).toHaveBeenCalled();
	});
	
	function createStubs() {
		model = { postSearch: function(){} };
		view = {
			searchField: function(){ return $('#search'); },
			searchButton: function(){ return $('#go'); },
			closeButton: function(){ return $('#close'); },
			deleteButton: function(){ return $('#delete'); },
			closeSearch: function(){},
			makeItDelete: function(){},
			resetSearch: function(){},
			populateForm: function(){},
			showError: function(){}
		};
		
		realAnimate = animate;
		animate = function(){};
	}
	
	function restoreFunctions() {
		animate = realAnimate;
	}
	
});