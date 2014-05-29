//= require jquery
//= require jquery_ujs
//= require jquery-ui-autocomplete

//= require voting
//= require script-notifier
$(document).ready(function(){
	if($('#password').val() == "Passwort" || $('#password').val() == ""){
		$('#password').attr('type','text');
	}
	$('#email').focus(function(){
		if($('#email').val() == "Rats-Mailaddresse" || $('#email').val() == ""){
			$('#email').val('');
		}
	});
	$('#email').blur(function(){
		if($('#email').val() == "Rats-Mailaddresse" || $('#email').val() == ""){
			$('#email').val('Rats-Mailaddresse');
		}
	});
	$('#password').focus(function(){
		if($('#password').val() == "Passwort" || $('#password').val() == ""){
			$('#password').attr('type','password');
			$('#password').val('');
		}
	});
	$('#password').blur(function(){
		if($('#password').val() == "Passwort" || $('#password').val() == ""){
			$('#password').attr('type','text');
			$('#password').val('Passwort');
		}
	});
});