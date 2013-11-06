require 'minitest/unit'
require 'minitest/autorun'
require 'rails'
require 'rubygems'
require 'mocha/setup'
require_relative '../lib/mongoid_model_maker'

module MongoidModelMaker
    def setup
    end
    
    def teardown
    end

    class FileHelper < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      def vars
        @vars || {}
      end

      def vars= val
        @vars = val
      end
    end
end
