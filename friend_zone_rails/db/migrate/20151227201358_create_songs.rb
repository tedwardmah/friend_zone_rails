class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :spotify_uri
      t.string :added_by_uri
      t.string :added_by_username
      t.string :added_by_uri
      t.string :added_on
      t.references :user
      t.references :playlist

      t.timestamps
    end
  end
end
