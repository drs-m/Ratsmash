json.array!(@class_trips) do |class_trip|
  json.extract! class_trip, :id, :sender, :course, :text
  json.url class_trip_url(class_trip, format: :json)
end
