json.array!(@polls) do |poll|
  json.extract! poll, :id, :name, :description
  json.url poll_url(poll, format: :json)
end
