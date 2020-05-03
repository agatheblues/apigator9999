# frozen_string_literal: true

json.users @users do |user|
  json.id user.id
  json.email user.email
  json.username user.username
  json.confirmed_at user.confirmed_at
  json.role user.role
end
