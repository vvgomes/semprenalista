var focused = false;
document.onkeydown = function() {
	if(!focused) {
		document.getElementsByName('name')[0].focus();
		focused = true;
	}
};
