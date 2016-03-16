require 'test_helper'


describe AreaController do
  before {
  }

  it "#GET /area/polygons - return application_code 400 with no parameters" do
    get :polygons
    res = JSON.parse(response.body)
    res['application_code'].must_equal 400
  end

  it "#GET /area/polygons - return application_code 200 and polygon array" do
    get :polygons, :south => 37.7, :north => 37.8, :west => -122.5, :east => -122.4
    res = JSON.parse(response.body)
    res['application_code'].must_equal 200
    res['polygons'].must_be_kind_of Array
  end
end
