class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :songs
  has_many :archives, dependent: :destroy
end
