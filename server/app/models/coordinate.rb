class Coordinate < ActiveRecord::Base
  validates_presence_of :polygon_id, :lat, :lng
  belongs_to :polygon
end
