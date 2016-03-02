require 'test_helper'


describe Coordinate do

  describe '#attributes' do
    it "#attributes are required" do
      Coordinate.new.valid?.must_equal false
    end
  end

end
