class AreaController < ApplicationController

=begin
  @apiVersion 0.1.0

  @apiGroup Area
  @api {get} /area/polygons
  @apiName Area#polygons
  @apiDescription get areas that aren't allowed to fly drone

  @apiParam {Number} south                     south
  @apiParam {Number} north                     north
  @apiParam {Number} east                      east
  @apiParam {Number} west                      west

  @apiParamExample {json} Request-Example:
    {
      "south": 37.7,
      "north": 37.8,
      "west": -122.5,
      "east": -122.4
    }

  @apiSuccess {Array} polygons
  @apiSuccess {Number} application_code if the request succeeded or failed

  @apiSuccessExample {json} Success-Response:
    {
      "polygons": [
        {
          "id": 1,
          "area_type": "hoge",
          "min_lat": 37.75,
          "min_lng": -122.45,
          "max_lat": 38.75,
          "max_lng": -121.45
        },
        ...
      ],
      "application_code": 200
    }
=end
  def polygons
    # params: the range to search polygons
    ranges = [:south, :north, :west, :east]
    ranges.each do |range|
      unless params[range]
        render json: { :application_code => 400, :description => "could not find parameter '#{range}'" }
        return
      end
    end
    south = params[:south].to_f
    north = params[:north].to_f
    west = params[:west].to_f
    east = params[:east].to_f

    # response: search the polygons overlapping the rectangle range
    polygons = Polygon.where(
      "(? > min_lat and ? < max_lat and ? > min_lng and ? < max_lng)"     +    # polygons contain range
      " or (min_lat > ? and min_lat < ? and min_lng > ? and max_lng < ?)" +    # range contains polygons
      " or (max_lat > ? and min_lat < ? and max_lng > ? and min_lng < ?)",     # intersection
      south, south, west, west,
      south, north, west, east,
      south, north, west, east
    )
    json = Jbuilder.encode do |j|
      j.polygons(polygons)
      j.application_code(200)
    end
    render json: json
  end

=begin
  @apiVersion 0.1.0

  @apiGroup Area
  @api {get} /area/can_fly
  @apiName Area#can_fly
  @apiDescription get if the coordinate is allowed to fly drone

  @apiParam {Boolean} lat                     coordinate latitude
  @apiParam {Number}  lng                     coordinate longitude

  @apiParamExample {json} Request-Example:
    {
      "lat": 37.7,
      "lng": -122.4
    }

  @apiSuccess {Number} can_fly Bool
  @apiSuccess {Number} application_code if the request succeeded or failed

  @apiSuccessExample {json} Success-Response:
    {
      "can_fly": 1,
      "application_code": 200
    }
=end
  def can_fly
    # params: coordinates
    coordinates = [:lat, :lng]
    coordinates.each do |coordinate|
      unless params[coordinate]
        render json: { :application_code => 400, :description => "could not find parameter '#{coordinate}'" }
        return
      end
    end
    lat = params[:lat].to_f
    lng = params[:lng].to_f

    # response: detect if there are any polygons containing the coordinates
      # get polygons
    polygons = Polygon.where(
      "? > min_lat and ? < max_lat and ? > min_lng and ? < max_lng",
      lat, lat, lng, lng
    )
      # detection
    can_fly = true
    polygons.each do |polygon|
      locations = []
      polygon.coordinates.each do |coordinate|
        locations.push(Geokit::LatLng.new(coordinate.lat, coordinate.lng))
      end
      if Geokit::Polygon.new(locations).contains?(Geokit::LatLng.new(lat, lng))
        can_fly = false
        break
      end
    end
      # response
    json = Jbuilder.encode do |j|
      j.can_fly(can_fly)
      j.application_code(200)
    end
    render json: json
  end

end
