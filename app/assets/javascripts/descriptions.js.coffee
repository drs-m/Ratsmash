$ ->
    
    $("#description_described_name").autocomplete
        messages:
            result: (count) ->
            noResults: ''   
        source: (request, response) ->
            $.get "/vote/autocomplete.json?q=#{request.term}", (data) ->
                suggestions = []
                if data.status == "success"
                    suggestions.push result.name for result in data.results
                response suggestions
