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
		$("#little_menue").slideToggle(0);
	});

	if(window.location.pathname == "/project_goes_live"){
		$.ajax({
			url: "get_mail_status",
			type: "post"
		})
		.done(function(data){
			if(!data[0]){
				$("body").mousemove(function(e){
					var x = e.clientX;
					var y = e.clientY;
					$("#stempel_cursor").css("top",y+1);
					$("#stempel_cursor").css("left",x+1);
					$("body").css("cursor","none");
				});
			}
			else{
				$("#stempel_cursor").css("top",data[2]);
				$("#stempel_cursor").css("left",data[1]);
				$("#send_mail_button").attr("disabled","disabled");
			}
		});

		$("#send_mail_button").click(function(e){
			var x = e.clientX;
			var y = e.clientY;
			$.ajax({
				url: "/send_mails_to_students",
				type: "POST",
				data: "xpos="+x+"&ypos="+y
			}).done(function(){
				location.reload();
			});
			return false;
		});
	}
});