class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :name
      t.string :spotify_uri
      t.string :snapshot_id
      t.string :collaboration_name
      t.string :year
      t.string :month
      t.references :playlist

      t.timestamps
    end
  end
end
