class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :spotify_uri
      t.string :snapshot_id
      t.string :prior_snapshot_id
      t.string :collaboration_name
      t.string :year
      t.string :month

      t.timestamps
    end
  end
end
