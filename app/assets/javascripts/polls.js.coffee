###
function add_poll_voting_opportunity(){
	poll_option_fields_counter ++;
	var poll_options_html = $('#poll_options').html();
	var new_poll_option_field = '<b>Votingmöglichkeit</b> <input id="voting_ops_'+(poll_option_fields_counter-1)+'" name="voting_ops['+(poll_option_fields_counter-1)+']" value="" onkeyup="store_poll_option_values('+(poll_option_fields_counter-1)+');" type="text" /><br /><br />';
	voting_op_values.push("");
	$('#poll_options').html(poll_options_html+new_poll_option_field);
	for (var i = 0; i < voting_op_values.length; i++) {
		$("#voting_op_"+i).val(voting_op_values[i]);
	};
}
###

@poll_option_counter = 2

@add_poll_vote_field = ->
    option_list = $("#poll_options")
    new_element_html = "<p>Votingmöglichkeit: <input id='voting_ops_#{@poll_option_counter}' name='voting_ops[#{@poll_option_counter}]' type='text' /></p>"
    option_list.append new_element_html
    ++@poll_option_counter
