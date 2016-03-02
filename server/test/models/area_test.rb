require 'test_helper'


describe Area do

  describe '#attributes' do
    it "#attributes are required" do
      Area.new.valid?.must_equal false
    end
  end

end
