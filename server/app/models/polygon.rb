class Polygon < ActiveRecord::Base
  validates_presence_of :area_id
  belongs_to :area
  has_many :coordinates, dependent: :destroy
end
