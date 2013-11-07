require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class FactoriesGenerator < Rails::Generators::Base
    argument :model, type: :string, required: true, desc: "Name of model"
    argument :fields, type: :array, desc: "List of space separated pairs, colon separated, of field name and field type"
    class_option :read_factories, type: :boolean, default: false, required: false, desc: "If true will read one line of ruby code form stdin for each field, respectively"
    class_option :parent, type: :string, required: false, desc: "Name of parent model"
    class_option :plural, type: :boolean, required: false, desc: "Type of parent model relationship"

    def call_factory_girl_generator
      Rails::Generators.invoke "factory_girl:model", [model, fields].flatten
    end

    def add_singular_references_in_parent_factory
      create_file "model", model
      create_file "fields", fields.to_s
    end

  end
end
