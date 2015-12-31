class Song < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :user
  belongs_to :archive
end
