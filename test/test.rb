require 'test/unit'
require 'rubygems'
require_relative '../lib/generators/mongoid_model_maker'

module MongoidModelMaker
  class GeneratorTest < Test::Unit::TestCase
    def setup
    end
    
    def test_version
      assert MongoidModelMaker::VERSION == "0.0.3"
    end

    def teardown
    end
  end
end
