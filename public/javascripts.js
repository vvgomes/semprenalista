$(document).ready(function() {	
		
	$('input[name=name]').focus();
	
	$('form').validate({ 
		rules: { 
   		name: 'required',
      email: 'required' 
    }, 
    messages: { 
      name: '*',
 			email: '*'
    } 
  });

});