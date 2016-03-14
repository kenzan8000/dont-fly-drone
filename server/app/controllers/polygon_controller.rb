class PolygonController < ApplicationController

=begin
  @apiVersion 0.1.0

  @apiGroup Polygon
  @api {get} /polygon
  @apiName Polygon#index
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
          "name": "hoge",
          "seller_id": 1,
          "lat": 37.75,
          "lng": -122.45
        },
        ...
      ],
      "application_code": 200
    }
=end
  def index
    # params
    ranges = [:south, :north, :west, :east]
    ranges.each do |range|
      unless params[range]
        render json: { :application_code => 400, :description => "could not find the #{range}" }
        return
      end
    end

    # response
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
