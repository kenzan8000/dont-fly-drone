class Area < ActiveRecord::Base
  validates_presence_of :name
  has_many :polygons, dependent: :destroy
end
