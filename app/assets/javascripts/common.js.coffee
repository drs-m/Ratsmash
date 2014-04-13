$ ->

	category = $("#category-heading").data "category"

	$(".candidate-input").autocomplete
		messages:
			result: (count) ->
			noResults: ''	

		source: (request, response) ->
			$.get "/vote/autocomplete?q=#{request.term}&c=#{category}", (data) ->
				suggestions = []
				suggestions.push(result.name) for result in data.results if data.status == "success"
				response suggestions

		# select: (event, ui) ->
