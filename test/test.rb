require 'minitest/unit'
require 'minitest/autorun'
require 'rails'
require 'rubygems'
require_relative '../lib/generators/mongoid_model_maker'

module MongoidModelMaker
  class GeneratorTest < Rails::Generators::TestCase
    tests MongoidModelMaker::FromYamlGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    def setup
    end
    
    test "version" do
      assert MongoidModelMaker::VERSION == "0.0.3"
    end

    test "from_yaml parent generator" do
      run_generator %w(test/fixtures/simple_model.yaml)
      puts `cat tmp/lolercakes`
      assert MongoidModelMaker::FromYamlGenerator
      assert false
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

    def teardown
    end
  end
end
