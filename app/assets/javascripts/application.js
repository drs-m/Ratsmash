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

	$("#little_menue_button").click(function(){
		isClicked = true;
		$("#little_menue").slideToggle(0);
	});
	$("body").mousemove(function(e){
		var x = e.clientX;
		var y = e.clientY;
		$("#stempel_cursor").css("top",y);
		$("#stempel_cursor").css("left",x);
	});
});