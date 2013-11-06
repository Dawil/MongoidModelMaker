require 'minitest/unit'
require 'minitest/autorun'
require 'rails'
require 'rubygems'
require 'mocha/setup'
require_relative '../lib/mongoid_model_maker'

module MongoidModelMaker
    module TestUtils
      def setup
        @file_helper = MongoidModelMaker::FileHelper.new
      end
      
      def teardown
      end
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
