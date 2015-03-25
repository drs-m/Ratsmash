json.array!(@child_pics) do |child_pic|
  json.extract! child_pic, :id, :sender_id, :image
  json.url child_pic_url(child_pic, format: :json)
end
