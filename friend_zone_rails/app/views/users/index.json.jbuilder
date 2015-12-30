json.array!(@users) do |user|
  json.extract! user, :id, :spotify_user_id, :access_token, :refresh_token, :name
  json.url user_url(user, format: :json)
end
