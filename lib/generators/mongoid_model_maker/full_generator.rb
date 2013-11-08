require 'rails'
require 'rails/generators'
require_relative '../../yaml_loader'

module MongoidModelMaker
  class FullGenerator < Rails::Generators::Base
    argument :schema, type: :string, required: true, desc: "Yaml schema file, describes models, relations and factories"

    def main
      MongoidModelMaker::Models.new(schema).run_all
    end
  end
end
