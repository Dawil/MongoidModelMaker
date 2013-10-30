require 'test/unit'
require 'rubygems'
require 'mongoid-model-maker'
require File.expand_path(File.dirname(__FILE__) + '/../lib/generators/mongoid_model_maker')

module MongoidModelMapper
  class GeneratorTest < Test::Unit::TestCase
    def setup
      puts "setup"
    end
    
    def test_version
      assert MongoidModelMapper::VERSION == "0.0.1"
    end

    def teardown
      puts 'sudoku'
    end
  end
end
