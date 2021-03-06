require 'json'
require './lib/assets/area_importer'


class Tasks::AreaImporterTask

  def self.import_demo_polygons
    # delete
    Polygon.delete_all

    # create
    file_names = ['5_mile_airport.geojson', 'us_military.geojson', 'us_national_park.geojson']
    area_types = ['airport', 'military', 'national_park']
    polygon_names = ['name', 'INSTALLATI', 'PARKNAME']
    area_importer = AreaImporter.new
    (0...file_names.length).each do |i|
      file = File.read("./../third-party/drone-feedback/sources/geojson/#{file_names[i]}")
      json = JSON.parse(file)
      area_importer.import_geojson(json, area_types[i], polygon_names[i])
    end
  end

end
