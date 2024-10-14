json.extract! admin, :id, :email, :uin, :first_name, :last_name, :role, :created_at, :updated_at
json.url admin_url(admin, format: :json)
