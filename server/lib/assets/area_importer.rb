require 'json'


# import area
class AreaImporter

  # import geojson to model
  def import_geojson(json)
    features = json['features']

    features.each do |feature|
#      # import area
#      area = import_area
#      next unless area
#      # import polygons
#      geometry = feature['geometry']
#      polygons = import_polygons(geometry)
#      next if polygons.length == 0
#      # save
#      area.save if area.valid?
#      polygon.each do |polygons|
#        polygon.save if polygon.valid?
#      end
    end
  end

#  # import area
#  def import_area(json)
#  end
#
#  # import polygons
#  def import_polygons(json)
#  end
#
#  # import coordinates
#  def import_coordinates(json)
#  end


end
