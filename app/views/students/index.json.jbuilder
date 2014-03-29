json.array!(@students) do |student|
  json.extract! student, :id, :first_name, :last_name, :gender, :mail_address, :password_digest, :password_resetkey, :admin_permissions
  json.url student_url(student, format: :json)
end
