json.array!(@quotes) do |quote|
  json.extract! quote, :id, :sender, :text, :teacher
  json.url quote_url(quote, format: :json)
end
