require 'yaml'
require 'rails'
require 'rails/generators'

# THIS file will probably get deleted
module MongoidModelMaker
  class ScaffoldGenerator < Rails::Generators::Base
    argument :source_file, type: :string, required: true, desc: "The source yaml file describing the models, relations and factories"

    def load_yaml
      @models = YAML::load_file( source_file )
    end

    def run_scaffolds
      @models.each do |model_name|
        
      end
    end
  end
end
