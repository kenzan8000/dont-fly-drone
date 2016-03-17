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

  it "#GET /area/can_fly - return application_code 400 with no parameters" do
    get :can_fly
    res = JSON.parse(response.body)
    res['application_code'].must_equal 400
  end

  it "#GET /area/can_fly - return application_code 200 and can_fly Boolean" do
    get :can_fly, :lat => 37.7, :lng => -122.4
    res = JSON.parse(response.body)
    res['application_code'].must_equal 200
    (res['can_fly'] == true || res['can_fly'] == false).must_equal true
  end
end
