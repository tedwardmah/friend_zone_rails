class Archive < ActiveRecord::Base
  belongs_to :playlist
  has_many :songs
end
