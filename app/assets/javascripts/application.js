// libraries
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require modernizr
//= require voting
//= require script-notifier

$(document).ready(function(){

	if(window.location.pathname == "/vote"){
		$("img").mousemove(function(e){
			$("#icon_info_box").css("display","block");
			$("#icon_info_box").css("top",e.clientY);
			$("#icon_info_box").css("left",e.clientX);
			$("#icon_info_box").html($(this).attr("alt"));
		});
		$("img").mouseout(function(){
			$("#icon_info_box").css("display","none");
		});
	}

	$("#webseite").click(function(){
		$("#acc_link_dd").css("display","none");
	});
	$(".account_link").click(function(){
		$("#acc_link_dd").slideToggle(0);
	});

	$("#little_menue_button").click(function(){
		$("#little_menue").slideToggle(0);
	});

	if(window.location.pathname == "/release_state"){
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

				$("#send_mail_button").mousemove(function(){
					$("#stempel_cursor").attr("src","/assets/stempel_cursor_hover.png");
				});
				$("#send_mail_button").mouseout(function(){
					$("#stempel_cursor").attr("src","/assets/stempel_cursor.png");
				});
			}
			else{
				$("#send_mail_button").attr("disabled","disabled");
				$("#stempel_cursor").css("display","none");
				var stempelabdruck = $("#stempelabdruck")
				var offset = parseInt(stempelabdruck.css("height")) / 2;
				stempelabdruck.css("display","block");
				stempelabdruck.css("top",data[2] - offset);
				stempelabdruck.css("left",data[1] - offset);
			}
		});

		$("#send_mail_button").click(function(e){
			var x = e.clientX;
			var y = e.clientY + 100;
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