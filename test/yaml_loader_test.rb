require_relative 'test_helper'

module MongoidModelMaker
  class YamlLoaderTest < MiniTest::Unit::TestCase
    def test_simple_load
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/simple_model.yaml" )
      assert @models.classes[:person][:first] == :string
      assert @models.classes[:person][:last]  == :string
    end

    def test_scaffolds_once
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/simple_model.yaml" )
      Rails::Generators.expects(:invoke).with("scaffold", "person first:string last:string")
      @models.run_scaffolds
    end

    def test_scaffolds_twice
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("scaffold", "person first:string last:string")
      Rails::Generators.expects(:invoke).with("scaffold", "dog name:string breed:string")
      @models.run_scaffolds
    end
  end
end
