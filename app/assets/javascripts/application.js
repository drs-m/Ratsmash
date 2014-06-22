//= require jquery
//= require jquery_ujs
//= require jquery-ui-autocomplete

//= require voting
//= require script-notifier

$(document).ready(function(){
	$("#webseite").click(function(){
		$("#acc_link_dd").css("display","none");
	});
	$(".account_link").click(function(){
		$("#acc_link_dd").slideToggle(0);
	});
});