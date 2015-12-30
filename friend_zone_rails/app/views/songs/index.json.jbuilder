json.array!(@songs) do |song|
  json.extract! song, :id, :spotify_uri, :added_by_uri, :added_by_username, :added_by_uri, :added_on
  json.url song_url(song, format: :json)
end
