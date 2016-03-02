require 'json'
require './lib/assets/area_importer'


class Tasks::AreaImporterTask

  def self.import_demo_area
    # delete
    Area.delete_all

    # create
    area_importer = AreaImporter.new
    area_types = ['airport', 'military', 'national_park']
    area_types.each do |area_name|
      area_importer.import_area(area_name)
    end
  end

  def self.import_demo_polygons
    # delete
    Polygon.delete_all

    # create
    file_names = [ '5_mile_airport.geojson', 'us_military.geojson', 'us_national_park.geojson' ]
    area_types = ['airport', 'military', 'national_park']
    area_importer = AreaImporter.new
    (0...file_names.length).each do |i|
      file = File.read("./../resources/geojsons/#{file_names[i]}")
      json = JSON.parse(file)
      area_importer.import_geojson(json, area_types[i])
    end
  end

end
