class AddArchiveIdToSongs < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.references :archive
    end
  end
end
