describe('search', function() {
	var search;
	var dom;
	var sendRequest;
	var controller;
	var emitter;

	beforeEach(function() {
		dom = fakeDom();
		emitter = new EventEmitter();
		search = createSearch(emitter);
		sendRequest = jasmine.createSpy('sendRequest');
		controller = search.createController(dom, sendRequest);
	});

	describe('controller', function() {

		it('should reset elements', function() {
			controller.reset();
			expect(dom.email().val()).toBe('');
			expect(dom.alert().hasClass('invisible')).toBeTruthy();
		});

		it('should show the alert', function() {
			controller.showAlert();
			expect(dom.alert().hasClass('invisible')).toBeFalsy();
		});

		it('should not send request when no email is provided', function() {
			dom.email().val('');
			controller.triggerSearch();
			expect(sendRequest).not.toHaveBeenCalled();
		});

		it('should send request when an email is provided', function() {
			controller.triggerSearch();
			expect(sendRequest).toHaveBeenCalled();
		});

		it('should show alert when there is no search results', function() {
			spyOn(controller, 'showAlert');
			controller.handleResponse();
			expect(controller.showAlert).toHaveBeenCalled();
		});

		it('should fire "populate" event after successful search', function() {
			var response = {};
			spyOn(emitter, 'emit');
			controller.handleResponse(response);
			expect(emitter.emit).toHaveBeenCalledWith('populate', response);
		});
	});

	describe('event binding', function() {

		it('should trigger controller.reset when box is shown', function() {
			spyOn(controller, 'reset');
			search.bindEvents(dom, controller);
			dom.box().trigger('shown');
			expect(controller.reset).toHaveBeenCalled();
		});

		it('should trigger controller.triggerSearch when ok is clicked', function() {
			spyOn(controller, 'triggerSearch');
			search.bindEvents(dom, controller);
			dom.ok().trigger('click');
			expect(controller.triggerSearch).toHaveBeenCalled();
		});

		it('should trigger controller.triggerSearch when return key is pressed on email', function() {
			spyOn(controller, 'triggerSearch');
			search.bindEvents(dom, controller);
			dom.email().trigger($.Event('keydown', {which: 13}));
			expect(controller.triggerSearch).toHaveBeenCalled();
		});

	});

	function fakeDom() {
		return {
			email: e($('<input type="text" value="marano@gmail.com"/>')),
			alert: e($('<div/>')),
			box: e($('<div/>')),
			ok: e($('<button/>'))
		};
	}
});

describe('form', function() {
	var form;
	var dom;
	var controller;
	var emitter;

	beforeEach(function() {
		dom = fakeDom();
		emitter = new EventEmitter();
		form = createForm(emitter);
		controller = form.createController(dom);
	});

	describe('controller', function() {

		it('should populate the form with clubber data to edit', function() {
			var data = {name: 'lipe', email: 'lipe@gmail.com', friends: ['marano']};
			controller.populate(data);
			expect(dom.name().val()).toBe('lipe');
			expect(dom.email().val()).toBe('lipe@gmail.com');
			expect(dom.friends(0).val()).toBe('marano');
			expect(dom.method().val()).toBe('put');
			expect(dom.del().hasClass('invisible')).toBeFalsy();
		});

		describe('after confirming deletion', function() {
			var submit = { click: function(){} };

			beforeEach(function() {
				dom.ok = function(){ return submit; };
				spyOn(submit, 'click');
				controller = form.createController(dom);
				controller.confirmDelete();
			});

			it('should change the form method to delete', function() {
				expect(dom.method().val()).toBe('delete');
			});

			it('should submit the form', function() {
				expect(submit.click).toHaveBeenCalled();
			});
		});
	});

	describe('event binding', function() {

		it('should trigger controller.populate when "populate" event is fired', function() {
			console.log('form is ', form);
			spyOn(controller, 'populate');
			form.bindEvents(dom, controller);
			emitter.emit('populate');
			expect(controller.populate).toHaveBeenCalled();
		});

		it('should trigger controller.confirmDelete when "yes" button is clicked', function() {
			spyOn(controller, 'confirmDelete');
			form.bindEvents(dom, controller);
			dom.delYes().trigger('click');
			expect(controller.confirmDelete).toHaveBeenCalled();
		});
	});

	function fakeDom() {
		return {
			name: e($('<input type="text" value=""/>')),
			email: e($('<input type="text" value=""/>')),
			friends: e($('<input type="text" value=""/>')),
			method: e($('<input type="hidden" value=""/>')),
			alert: e($('<div/>')),
			box: e($('<div/>')),
			ok: e($('<button/>')),
			del: e($('<button/>')),
			delBox: e($('<div/>')),
			delYes: e($('<button/>')),
			error: e($('<div/>')),
			notice: e($('<div/>'))
		};
	}
});
