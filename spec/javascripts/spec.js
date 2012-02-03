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
	var model, view, search;
	
	beforeEach(function() {
		$('body').append(html);
		createStubs();		
	});
	
	afterEach(function() {
		view.editLink().remove();
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
		search = { 
			takeControl: function(){}
		};
		
		searchController = function(){ return search; };
		
		model = {
			getSearch: function(c){ c(); }
		};
		
		view = {
			editLink: function(){ return $('#edit'); },
			okButton: function(){},
			deleteButton: function(){},
			showSearch: function(){} 
		};
		
		animate = function(){};
	};
	
});