require 'test/unit'
require 'rubygems'
require 'mongoid_model_maker'

module MongoidModelMaker
  class GeneratorTest < Test::Unit::TestCase
    def setup
      puts "setup"
    end
    
    def test_version
      assert MongoidModelMaker::VERSION == "0.0.1"
    end

    def teardown
      puts 'sudoku'
    end
  end
end
