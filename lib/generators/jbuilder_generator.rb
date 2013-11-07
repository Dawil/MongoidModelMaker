require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class JBuilderGenerator < Rails::Generators::Base
    argument :model, type: :string, required: true, desc: "Name of model to create"
    argument :fields, type: :array, desc: "Space separated list of fields of format name:type"
    class_option :parent, type: :string, desc: "Parent model"
    class_option :plural, type: :boolean, default: false, desc: "True if the model is a plural (has_many, embedded_many) relationship"

    def create_partial
      field_names = fields.map { |field| ":#{field.split(':')[0]}" }
      contents = <<RUBY
json.id #{model.underscore}.id
json.extract! #{model.underscore}, :created_at, :updated_at#{ ", #{field_names.join(', ')}" if field_names.length > 0 }
RUBY
      create_file "app/views/#{model.pluralize.underscore}/_#{model.underscore}.json.jbuilder", contents
    end

    def call_partial
      model_plural = model.pluralize.underscore
      model_singular = model.underscore
      create_file "app/views/#{model_plural}/index.json.jbuilder", <<RUBY
json.array!(@#{model_plural}) do |#{model_singular}|
  json.partial! "#{model_plural}/#{model_singular}.json.jbuilder", #{model_singular}: #{model_singular}
end
RUBY

      create_file "app/views/#{model_plural}/show.json.jbuilder", <<RUBY
json.partial! "#{model_plural}/#{model_singular}.json.jbuilder", #{model_singular}: @#{model_singular}
RUBY
    end

    def add_singular_relations
      if options[:parent] and not options[:plural]
        append_to_file "app/views/#{options[:parent].pluralize.underscore}/_#{options[:parent].underscore}.json.jbuilder", <<RUBY
json.#{model.underscore} do
  json.partial! "app/views/#{model.pluralize.underscore}/#{model.underscore}.json.jbuilder", #{model.underscore}: #{options[:parent].underscore}.#{model.underscore}
end if #{options[:parent].underscore}.#{model.underscore}
RUBY
      end
    end

    def add_plural_relations
      if options[:parent] and options[:plural]
        append_to_file "app/views/#{options[:parent].pluralize.underscore}/_#{options[:parent].underscore}.json.jbuilder", <<RUBY
json.#{model.pluralize.underscore} do
  json.array!(#{options[:parent].underscore}.#{model.pluralize.underscore}) do |#{model.underscore}|
    json.partial! "app/views/#{model.pluralize.underscore}/#{model.underscore}.json.jbuilder", #{model.underscore}: #{model.underscore}
  end
end
RUBY
      end
    end
  end
end
