$dom.onready(function(){
	console.log('executing onready');
	var showDialog = function() {
		console.log('hey');
		$dom.removeClass(dialogDiv(), 'invisible');
	};
	
	editLink().onclick = showDialog;
	
	function dialogDiv() {
		return $dom.get('#dialog');
	}
	function editLink() {
		return $dom.get('#edit');
	}
});
