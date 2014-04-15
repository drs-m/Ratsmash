if @error
	json.status "error"
	json.message @error
else
	json.status "success"
	json.results do
		json.array! @results, :name
	end
end
