$ ->
	category = $("#category-heading").data "category"

	$(".candidate-input").autocomplete
		messages:
			result: (count) ->
			noResults: ''	

		source: (request, response) ->
			$.get "/vote/autocomplete?q=#{request.term}&c=#{category}", (data) ->
				suggestions = []
				suggestions.push({label: result.name, value: result.type + result.id}) for result in data.results if data.status == "success"
				response suggestions

		select: (event, ui) ->
			# set the label into the text-input instead of the value
			event.preventDefault()
			$(this).val ui.item.label
			# substr(start, length)
			type = ui.item.value.substr(0, 1)
			id = ui.item.value.substr(1)
			form_e = $(this).parent()
			form_e.find(".ftchd_cand_type").val type
			form_e.find(".ftchd_cand_id").val id

		focus: (event, ui) ->
			# set the label into the text-input instead of the value
			event.preventDefault()
			$(this).val ui.item.label


	$(".voting-form").on "submit", ->
		event.preventDefault()
		console.log "submitted"
