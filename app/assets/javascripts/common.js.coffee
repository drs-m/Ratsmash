$(document).ready ->

	$(".candidate-input").autocomplete
		source: ["Darius", "David", "Daphne", "Fredicus", "Johann"]
		messages:
			noResults: ''
			results: ''


	###
	$(".candidate-input").on "keyup", ->
		$.get "/vote/autocomplete?q=" + $(this).val() + "&c=" + $("#category-heading").data("category"), (data) ->
			console.log data.results
	###
