class Polygon < ActiveRecord::Base
  validates_presence_of :area_type, :name, :min_lat, :min_lng, :max_lat, :max_lng

  has_many :coordinates, dependent: :destroy
end
