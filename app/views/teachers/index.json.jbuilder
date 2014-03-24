json.array!(@teachers) do |teacher|
  json.extract! teacher, :id, :first_name, :last_name, :gender
  json.url teacher_url(teacher, format: :json)
end
