require 'yaml'
require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class ScaffoldGenerator < Rails::Generators::Base
    argument :source_file, type: :string, required: true, desc: "The source yaml file describing the models, relations and factories"

    def run_scaffolds
      @models = YAML::load_file( source_file )
      create_file "log", @models.to_s
      fields = @models['person']['fields'].map do |field|
        "#{field[:name]}:#{field[:type]}"
      end
      Rails::Generators.invoke 'scaffold', fields
      Rails::Generators.invoke 'scaffold', fields
    end
  end
end
