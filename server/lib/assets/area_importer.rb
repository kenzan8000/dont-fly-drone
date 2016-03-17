# import area
class AreaImporter

  # constant
  GEOMETRY_TYPES = ['Polygon', 'MultiPolygon']

  COORDINATES_ARRAY_DEPTH_POLYGON = 3
  COORDINATES_ARRAY_DEPTH_MULTIPLE_POLYGONS = 4


  # import geojson to model
  def import_geojson(json, area_type)
    features = json['features']
    features.each do |feature|
      # import coordinates
      coordinates_array = import_coordinates_array(feature)
      next unless coordinates_array

      # import polygons
      polygons = import_polygons(coordinates_array, area_type)
      next if polygons.length == 0
    end
  end

  # get array depth
  def array_depth(coordinates)
    return 0 unless coordinates.is_a?(Array)
    1 + array_depth(coordinates[0])
  end

  # check if coordinates are polygon or multiple polygons?
  def coordinates_are_polygon_or_multiple_polygons?(depth)
    (depth == COORDINATES_ARRAY_DEPTH_POLYGON || depth == COORDINATES_ARRAY_DEPTH_MULTIPLE_POLYGONS)
  end

  # import coordinates
  def import_coordinates_array(json)
    # get coordinates array
    geometry = json['geometry']
    coordinates_wrapper = geometry['coordinates']
    depth = array_depth(coordinates_wrapper)
    return nil unless coordinates_are_polygon_or_multiple_polygons?(depth)

    # return coordinates
    coordinates = []
    if depth == COORDINATES_ARRAY_DEPTH_POLYGON
      coordinates.append(import_polygon_coordinates(coordinates_wrapper))
    else
      coordinates_wrapper.each do |coordinates_wrapper_2|
        coordinates.append(import_polygon_coordinates(coordinates_wrapper_2))
      end
    end
    coordinates
  end

  # import polygon coordinates from json array
  def import_polygon_coordinates(json)
    coordinates = []

    json.each do |coordinates_array|
      # create coordinate
      coordinates_array.each do |coordinates_pair|
        next unless coordinates_pair.length == 2

        coordinate = Coordinate.new
        coordinate.lng = coordinates_pair[0]
        coordinate.lat = coordinates_pair[1]
        coordinates.push(coordinate)
      end
    end

    coordinates
  end

  # import polygons
  def import_polygons(coordinates_array, area_type)
    polygons = []
    coordinates_array.each do |coordinates|
      # create polygon
      polygon = Polygon.new
      polygons.push(polygon)
      polygon.area_type = area_type

      min_lat = 180.0
      min_lng = 180.0
      max_lat = -180.0
      max_lng = -180.0
      coordinates.each do |coordinate|
        min_lat = coordinate.lat if coordinate.lat < min_lat
        min_lng = coordinate.lng if coordinate.lng < min_lng
        max_lat = coordinate.lat if coordinate.lat > max_lat
        max_lng = coordinate.lng if coordinate.lng > max_lng
      end
      polygon.min_lat = min_lat
      polygon.min_lng = min_lng
      polygon.max_lat = max_lat
      polygon.max_lng = max_lng

      next unless polygon.valid?
      polygon.save

      # save coordinate
      coordinates.each do |coordinate|
        polygon.coordinates << coordinate
        coordinate.polygon_id = polygon.id
        coordinate.save if coordinate.valid?
      end
    end
    polygons
  end

end

