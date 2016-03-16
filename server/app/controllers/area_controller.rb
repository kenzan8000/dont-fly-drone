class AreaController < ApplicationController

=begin
  @apiVersion 0.1.0

  @apiGroup Area
  @api {get} /area/polygons
  @apiName Area#index
  @apiDescription get Polygons in the range

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

    # response: search the polygons overlapping the range
    polygons = Polygon.where(
      "max_lat > ? and min_lat < ? and max_lng > ? and min_lng < ?",
      params[:south].to_f, params[:north].to_f,
      params[:west].to_f, params[:east].to_f
    )
    json = Jbuilder.encode do |j|
      j.polygons(polygons)
      j.application_code(200)
    end
    render json: json
  end

end
