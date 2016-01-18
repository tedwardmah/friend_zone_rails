class AddBackupIdToSongs < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.references :backup
    end
  end
end
