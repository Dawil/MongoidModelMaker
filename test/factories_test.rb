require_relative 'test_helper'

module MongoidModelMaker
  class FactoriesTest < Rails::Generators::TestCase
    include MongoidModelMaker::TestUtils
    tests MongoidModelMaker::FactoriesGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "that there are tests" do
      assert false
    end
  end
end
