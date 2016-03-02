require 'test_helper'


describe Polygon do

  describe '#attributes' do
    it "#attributes are required" do
      Polygon.new.valid?.must_equal false
    end
  end

end
