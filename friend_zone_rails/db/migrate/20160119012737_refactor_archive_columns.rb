class RefactorArchiveColumns < ActiveRecord::Migration
  def change
    change_table :archives do |t|
      t.boolean :is_master
      t.string :frequency
    end
  end
end
