require 'yaml'
require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class FromYamlGenerator < Rails::Generators::Base
    argument :source_file, type: :string, required: true, desc: "The source yaml file describing the models, relations and factories"

    def load_yaml_file
      puts source_file
      models = YAML::load_file(source_file)
      create_file "lolercakes", models.to_s
    end
  end
end
