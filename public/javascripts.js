$(document).ready(function() {	
	
	$('input[name=nome]').focus();
	
	$('form').validate({ 
		rules: { 
   		nome: 'required',
      email: 'required' 
    }, 
    messages: { 
      nome: 'Obrigat&oacute;rio :(',
 			email: 'Obrigat&oacute;rio :('
    } 
  });

});