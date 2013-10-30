require 'minitest/unit'
require 'minitest/autorun'
require 'rails'
require 'rubygems'
require_relative '../lib/generators/mongoid_model_maker'

module MongoidModelMaker
  class GeneratorTest < Rails::Generators::TestCase
    def setup
    end
    
    test "version" do
      assert MongoidModelMaker::VERSION == "0.0.3"
    end

    def teardown
    end
  end
end
