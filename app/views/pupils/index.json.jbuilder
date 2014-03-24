json.array!(@pupils) do |pupil|
  json.extract! pupil, :id, :first_name, :last_name, :gender, :mail_address, :password_digest, :password_resetkey, :admin_permissions
  json.url pupil_url(pupil, format: :json)
end
