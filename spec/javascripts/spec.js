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

describe('search controller', function() {
	
	it('should do something', function() {
		
	});
	
});