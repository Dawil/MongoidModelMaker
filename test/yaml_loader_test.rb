require_relative 'test_helper'

module MongoidModelMaker
  class YamlLoaderTest < MiniTest::Unit::TestCase
    def test_scaffolds
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("scaffold", %w(person first:string last:string --timestamps))
      Rails::Generators.expects(:invoke).with("scaffold", %w(dog name:string breed:string --timestamps))
      @models.run_scaffolds
    end

    def test_relations
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke)
        .with("relations", %w(dog --parent=person --relation=embeds_many))
      @models.run_relations
    end

    def test_factories
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("factories", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("factories", %w(dog name:string breed:string --plural=true --parent=person))
      @models.run_factories
    end

    def test_jbuilders
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("jbuilder", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("jbuilder", %w(dog name:string breed:string --plural=true --parent=person))
      @models.run_jbuilders
    end

    def test_run_all
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("scaffold", %w(person first:string last:string --timestamps))
      Rails::Generators.expects(:invoke).with("scaffold", %w(dog name:string breed:string --timestamps))
      Rails::Generators.expects(:invoke).with("relations", %w(dog --parent=person --relation=embeds_many))
      Rails::Generators.expects(:invoke).with("factories", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("factories", %w(dog name:string breed:string --plural=true --parent=person))
      Rails::Generators.expects(:invoke).with("jbuilder", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("jbuilder", %w(dog name:string breed:string --plural=true --parent=person))
      @models.run_all
    end
  end
end
