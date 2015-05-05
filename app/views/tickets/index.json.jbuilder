json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :student_id, :amount
  json.url ticket_url(ticket, format: :json)
end
