require_relative 'test_helper'

module MongoidModelMaker
  class GeneratorTest < Rails::Generators::TestCase
    tests MongoidModelMaker::FromYamlGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "version" do
      assert MongoidModelMaker::VERSION == "0.0.3"
    end

    test "from_yaml parent generator" do
      run_generator %w(test/fixtures/simple_model.yaml)
      assert MongoidModelMaker::FromYamlGenerator
    end

    test "models generator" do
      assert MongoidModelMaker::ModelGenerator
    end

    test "scaffold generator" do
      assert MongoidModelMaker::ScaffoldGenerator
    end

    test "factories generator" do
      assert MongoidModelMaker::FactoryGenerator
    end

    test "graphviz generator" do
      assert MongoidModelMaker::GraphvizGenerator
    end

  end
end
