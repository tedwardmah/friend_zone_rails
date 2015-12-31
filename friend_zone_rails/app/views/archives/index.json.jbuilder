json.array!(@archives) do |archive|
  json.extract! archive, :id, :name
  json.url archive_url(archive, format: :json)
end
