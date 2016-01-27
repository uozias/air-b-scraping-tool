class Room < ActiveRecord::Base

  validates_uniqueness_of :airbnb_id
end
