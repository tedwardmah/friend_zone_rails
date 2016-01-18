json.array!(@backups) do |backup|
  json.extract! backup, :id, :name, :spotify_uri, :snapshot_id, :collaboration_name, :year, :month, :is_archive_backup
  json.url backup_url(backup, format: :json)
end
