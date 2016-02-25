class Area < ActiveRecord::Base
  validates_presence_of :type, :name
  has_many :polygons, dependent: :destroy
end
