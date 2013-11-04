require_relative 'test_helper'

module MongoidModelMaker
  class YamlLoaderTest < MiniTest::Unit::TestCase
    def test_simple_load
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/simple_model.yaml" )
      assert @models.classes[:person][:first]
    end
  end
end
