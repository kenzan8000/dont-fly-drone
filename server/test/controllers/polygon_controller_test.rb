require 'test_helper'


describe PolygonController do
  before {
  }

  it "#GET /polygon - return application_code 400 with no parameters" do
    get :index
    res = JSON.parse(response.body)
    res['application_code'].must_equal 400
  end

  it "#GET /polygon - return application_code 200 and polygon array" do
    get :index, :south => 37.7, :north => 37.8, :west => -122.5, :east => -122.4
    res = JSON.parse(response.body)
    res['application_code'].must_equal 200
    res['polygons'].must_be_kind_of Array
  end
end
