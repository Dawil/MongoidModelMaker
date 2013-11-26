require_relative 'test_helper'

module MongoidModelMaker
  class YamlLoaderTest < MiniTest::Unit::TestCase
    def test_scaffolds
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("rails:scaffold", %w(person first:string last:string --timestamps))
      Rails::Generators.expects(:invoke).with("rails:scaffold", %w(dog name:string breed:string --timestamps))
      @models.run_scaffolds
    end

    def test_relations
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke)
        .with("mongoid_model_maker:relation", %w(--child=dog --parent=person --relation=embeds_many))
      @models.run_relations
    end

    def test_relations_with_synonyms
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model_with_synonyms.yaml" )
      Rails::Generators.expects(:invoke)
        .with("mongoid_model_maker:relation", %w(--child=dog --parent=person --relation=embeds_many --child_synonym=doggie))
      @models.run_relations
    end

    def test_factories
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:factory", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:factory", %w(dog name:string breed:string --plural=true --parent=person))
      @models.run_factories
    end

    def test_factories_with_syonyms
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model_with_synonyms.yaml" )
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:factory", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:factory", %w(dog name:string breed:string --plural=true --parent=person --child_synonym=doggie))
      @models.run_factories
    end

    def test_factories_with_custom_code
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/simple_model_with_factories.yaml" )
      Rails::Generators.stubs(:invoke).with("mongoid_model_maker:factory", %w(person first:string:{\ Faker::Name.first_name\ } last:string:{\ Faker::Name.last_name\ }))
      @models.run_factories
    end

    def test_jbuilders
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(dog name:string breed:string --plural=true --parent=person))
      @models.run_jbuilders
    end

    def test_jbuilders_with_synonyms
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model_with_synonyms.yaml" )
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(dog name:string breed:string --plural=true --parent=person --child_synonym=doggie))
      @models.run_jbuilders
    end

    def test_jbuilders_with_nested_synonyms
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/triple_model_with_nested_synonyms.yaml" )
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(cat name:string))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(person first:string last:string --plural=false --parent=cat --child_synonym=peep))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(dog name:string breed:string --plural=true --parent=person --parent_synonym=peep --child_synonym=doggie))
      @models.run_jbuilders
    end

    def test_run_all
      @models = MongoidModelMaker::Models.new File.join( __dir__, "fixtures/double_model.yaml" )
      Rails::Generators.expects(:invoke).with("rails:scaffold", %w(person first:string last:string --timestamps))
      Rails::Generators.expects(:invoke).with("rails:scaffold", %w(dog name:string breed:string --timestamps))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:relation", %w(--child=dog --parent=person --relation=embeds_many))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:factory", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:factory", %w(dog name:string breed:string --plural=true --parent=person))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(person first:string last:string))
      Rails::Generators.expects(:invoke).with("mongoid_model_maker:j_builder", %w(dog name:string breed:string --plural=true --parent=person))
      @models.run_all
    end
  end
end
