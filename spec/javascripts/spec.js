describe('highlight animation', function() {
	var animation, button;
	var html = '<input id="ok" type="button"/>';
	var darker = 'rgb(80, 80, 80)';
	var normal = 'rgb(128, 128, 128)';

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
			$.get = function(path, c){ c(); };
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
	
	describe('fetching the delte dialog', function() {
		
		it('should invoke the callback', function() {
			$.get = function(path, c){ c(); };
			view = { showDeleteDialog: function(){} };
			
			spyOn(view, 'showDeleteDialog');
			model.getDeleteDialog(view.showDeleteDialog);
			expect(view.showDeleteDialog).toHaveBeenCalled();
		});
		
	});
	
});

describe('index controller', function() {
	var model, view, fakeSearchController, realSearchController, realAnimate;
	var html = '<a id="edit" href="#"/>';
	
	beforeEach(function() {
		$('body').append(html);
		createStubs();
	});
	
	afterEach(function() {
		view.editLink().remove();
		restoreFunctions();
	});
		
	it('should give control to search controller when edit link is clicked', function() {
		spyOn(fakeSearchController, 'takeControl');
		indexController(model, view).takeControl();
		view.editLink().trigger('click');
		expect(fakeSearchController.takeControl).toHaveBeenCalled();
	});
	
	function createStubs() {
		fakeSearchController = { takeControl: function(){} };
		model = {};
		view = {
			editLink: function(){ return $('#edit'); },
			okButton: function(){},
			deleteButton: function(){}
		};
		
		realSearchController = searchController;
		searchController = function(){ return fakeSearchController; };
		
		realAnimate = animate;
		animate = function(){};
	}
	
	function restoreFunctions() {
		searchController = realSearchController;
		animate = realAnimate;
	}
	
});

describe('search controller', function() {
	var model, view, fakeDeleteController, realDeleteController, realAnimate;
	var html = 
		'<input type="search" id="search" value="foo"/>'+
    '<input type="button" id="go"/>'+
    '<input type="button" id="close"/>'+
		'<input type="button" id="delete"/>';
	
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
	
	it('should ask model for the search box', function() {
		spyOn(model, 'getSearch');
		searchController(model, view).takeControl();
		expect(model.getSearch).toHaveBeenCalled();
	});
	
	it('should ask view to show the search box', function() {
		spyOn(view, 'showSearch');
		searchController(model, view).takeControl();
		expect(view.showSearch).toHaveBeenCalled();
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
	
	it('should give control to delete controller when delete button is clicked', function() {
		spyOn(fakeDeleteController, 'takeControl');
		searchController(model, view).takeControl();
		view.deleteButton().trigger('click');
		expect(fakeDeleteController.takeControl).toHaveBeenCalled();
	});
	
	function createStubs() {
		fakeDeleteController = { takeControl: function(){} };
		model = { 
			getSearch: function(c){ c(); },
			postSearch: function(){} 
		};
		view = {
			searchField: function(){ return $('#search'); },
			searchButton: function(){ return $('#go'); },
			closeButton: function(){ return $('#close'); },
			deleteButton: function(){ return $('#delete'); },
			showSearch: function(){}, 
			closeSearch: function(){},
			resetSearch: function(){},
			populateForm: function(){},
			showError: function(){}
		};
		
		realDeleteController = deleteController;
		deleteController = function(){ return fakeDeleteController; };
		
		realAnimate = animate;
		animate = function(){};
	}
	
	function restoreFunctions() {
		deleteController = realDeleteController
		animate = realAnimate;
	}
	
});

describe('delete controller', function() {
	var model, view, realAnimate;
	var html = 
    '<input type="button" id="yes"/>'+
    '<input type="button" id="no"/>';
	
	beforeEach(function() {
		$('body').append(html);
		createStubs();		
	});
	
	afterEach(function() {
		view.yesButton().remove();
		view.noButton().remove();
		restoreFunctions();
	});
		
	it('should ask model for the delete dialog', function() {
		spyOn(model, 'getDeleteDialog');
		deleteController(model, view).takeControl();
		expect(model.getDeleteDialog).toHaveBeenCalled();
	});
	
	it('should ask view to show the delete dialog', function() {
		spyOn(view, 'showDeleteDialog');
		deleteController(model, view).takeControl();
		expect(view.showDeleteDialog);
	});
	
	it('should ask view to close delete dialog when cancel button is clicked', function() {
		spyOn(view, 'closeDeleteDialog');
		deleteController(model, view).takeControl();
		view.noButton().trigger('click');
		expect(view.closeDeleteDialog);
	});
	
	it('should ask view to submit form when confirm button is clicked', function() {
		spyOn(view, 'submitDelete');
		deleteController(model, view).takeControl();
		view.yesButton().trigger('click');
		expect(view.submitDelete);
	});
	
	function createStubs() {
		fakeDeleteController = { takeControl: function(){} };
		model = { getDeleteDialog: function() {} };
		view = {
			noButton: function(){ return $('#no'); },
			yesButton: function(){ return $('#yes'); },
			showDeleteDialog: function(){}, 
			closeDeleteDialog: function(){}, 
			submitDelete: function(){}
		};
		
		realAnimate = animate;
		animate = function(){};
	}
	
	function restoreFunctions() {
		animate = realAnimate;
	}
	
});