class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.string :name
      t.string :spotify_uri
      t.string :snapshot_id
      t.string :collaboration_name
      t.string :year
      t.string :month
      t.boolean :is_archive_backup
      t.references :playlist

      t.timestamps
    end
  end
end
