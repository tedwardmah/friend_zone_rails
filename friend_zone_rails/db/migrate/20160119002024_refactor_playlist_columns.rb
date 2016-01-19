class RefactorPlaylistColumns < ActiveRecord::Migration
  def change
    change_table :playlists do |t|
      t.remove :year, :month, :prior_snapshot_id
      t.string :rolloff_frequency
      t.string :owner
      t.boolean :repeats_allowed
    end
  end
end
