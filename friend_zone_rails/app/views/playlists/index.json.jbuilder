json.array!(@playlists) do |playlist|
  json.extract! playlist, :id, :spotify_uri, :snapshot_id, :prior_snapshot_id, :collaboration_name, :year, :month
  json.url playlist_url(playlist, format: :json)
end
