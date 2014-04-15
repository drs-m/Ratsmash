$ ->
	category = $("#category-heading").data "category"

	$(".candidate-input").autocomplete
		messages:
			result: (count) ->
			noResults: ''	
		source: (request, response) ->
			$.get "/vote/autocomplete.json?q=#{request.term}&c=#{category}", (data) ->
				suggestions = []
				if data.status == "success"
					suggestions.push result.name for result in data.results
				response suggestions

	showSuccessMsg = (form, msg) ->
		$(form).find(".error-msg").fadeOut()
		$(form).find(".success-msg").fadeOut().text(msg).fadeIn()

	showErrorMsg = (form, msg) ->
		$(form).find(".success-msg").fadeOut()
		$(form).find(".error-msg").fadeOut().text(msg).fadeIn()

	# $(".voting-form").on "submit", ->
