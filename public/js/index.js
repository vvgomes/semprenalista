function createSearch(emitter) {
	return {

		sendRequest: function(email, callback) {
			$.get('/search', {email: email}, callback);
		},
		
		createDom: function() {
			var dom = {};
			dom.box = e('#search-box');
			dom.email = e('#search-email');
			dom.alert = e('#search-alert');
			dom.ok = e('#search-ok');
			return dom;
		},

		createController: function(dom, sendRequest) {
			var controller = {};

			controller.reset = function() {
				dom.email().val('');
				dom.alert().addClass('invisible');
			}

			controller.showAlert = function() {
				dom.alert().removeClass('invisible');
			}

			controller.triggerSearch = function() {
				var email = dom.email().val();
				if(!email) return;
				sendRequest(email, controller.handleResponse);
			}

			controller.handleResponse = function(response) {
				if(!response) {
					controller.showAlert();
					return;
				}
				emitter.emit('populate', response);
				dom.box().modal('hide');
			}

			return controller;
		},

		bindEvents: function(dom, controller) {
			dom.box().on('shown', controller.reset);
			dom.ok().bind('click', controller.triggerSearch);
			dom.email().bind('keydown', when(13, controller.triggerSearch));
		}
	};
};

function createForm(emitter) {
	return {

		createDom: function() {
			var f = {};
			f.ok = e('#submit');
			f.del = e('#delete');
			f.delBox = e('#delete-box');
			f.delYes = e('#delete-yes');
			f.error = e('#error');
			f.notice = e('#notice');
			f.name = e('#main-form input[name="name"]');
			f.email = e('#main-form input[name="email"]');
			f.method = e('#main-form input[name="_method"]');
			f.friends = function(i){ return e('#main-form input[name="friends['+i+']"]')(); };
			return f;
		},

		createController: function(dom) {
			var controller = {};

			controller.populate = function(data) {
				dom.name().val(data.name);
				dom.email().val(data.email);
				dom.email().attr('readonly', 'readonly');
				(data.friends.length).times(function(i) {
					dom.friends(i).val(data.friends[i]);
				});
				dom.method().val('put');
				dom.del().removeClass('invisible');
				dom.error().alert('close');
				dom.notice().alert('close');
				dom.name().get(0).focus();
			};

			controller.confirmDelete = function() {
				dom.delBox().modal('hide');
				dom.method().val('delete');
				dom.ok().click();
			};

			return controller;
		},

		bindEvents: function(dom, controller) {
			emitter.addListener('populate', controller.populate);
			dom.delYes().bind('click', controller.confirmDelete);
		}
	};	
};

$(document).ready(function(){
	createTweetButton();
	activateLink('home');

	(function(emitter) {

		(function() {
			var search = createSearch(emitter);
			var dom = search.createDom();
			var controller = search.createController(dom, search.sendRequest);
			search.bindEvents(dom, controller);
		})();

		(function() {
			var form = createForm(emitter);
			var dom = form.createDom();
			var controller = form.createController(dom);
			form.bindEvents(dom, controller);
		})();

	})(new EventEmitter());
});
