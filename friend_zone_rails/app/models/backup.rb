class Backup < ActiveRecord::Base
  belongs_to :playlist
  has_many :songs
end
