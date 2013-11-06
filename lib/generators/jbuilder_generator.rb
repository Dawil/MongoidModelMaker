require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class JBuilderGenerator < Rails::Generators::Base
    argument :model, type: :string, required: true, desc: "Name of model to create"
    argument :fields, type: :array, desc: "Space separated list of fields of format name:type"

    def create_partial
      field_names = fields.map { |field| ":#{field.split(':')[0]}" }
      contents = <<RUBY
json.id #{model.underscore}.id
json.extract! #{model.underscore}, :created_at, :updated_at#{ ", #{field_names.join(', ')}" if field_names.length > 0 }
RUBY
      create_file "app/views/#{model.pluralize.underscore}/_#{model.underscore}.json.jbuilder", contents
    end
  end
end
