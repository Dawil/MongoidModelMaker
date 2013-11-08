require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class JBuilderGenerator < Rails::Generators::Base
    argument :model, type: :string, required: true, desc: "Name of model to create"
    argument :fields, type: :array, desc: "Space separated list of fields of format name:type"
    class_option :parent, type: :string, desc: "Parent model"
    class_option :plural, type: :boolean, default: false, desc: "True if the model is a plural (has_many, embedded_many) relationship"
    class_option :child_synonym, type: :string, required: false, default: nil

    def create_partial
      model_name = (options[:child_synonym] or model)
      field_names = fields.map { |field| ":#{field.split(':')[0]}" }
      contents = <<RUBY
json.id #{model_name.underscore}.id
json.extract! #{model_name.underscore}, :created_at, :updated_at#{ ", #{field_names.join(', ')}" if field_names.length > 0 }
RUBY
      create_file "app/views/#{model.pluralize.underscore}/_#{model.underscore}.json.jbuilder", contents
    end

    def call_partial
      model_name = (options[:child_synonym] or model)
      model_plural = model.pluralize.underscore
      model_singular = model.underscore
      create_file "app/views/#{model_plural}/index.json.jbuilder", <<RUBY
json.array!(@#{model_plural}) do |#{model_name}|
  json.partial! "#{model_plural}/#{model}.json.jbuilder", #{model_singular}: #{model_singular}
end
RUBY

      create_file "app/views/#{model_plural}/show.json.jbuilder", <<RUBY
json.partial! "#{model_plural}/#{model}.json.jbuilder", #{model_singular}: @#{model_singular}
RUBY
    end

    def add_singular_relations
      if options[:parent] and not options[:plural]
        model_name = (options[:child_synonym] or model)
        append_to_file "app/views/#{options[:parent].pluralize.underscore}/_#{options[:parent].underscore}.json.jbuilder", <<RUBY
json.#{model_name.underscore} do
  json.partial! "#{model.pluralize.underscore}/#{model.underscore}.json.jbuilder", #{model_name.underscore}: #{options[:parent].underscore}.#{model_name.underscore}
end if #{options[:parent].underscore}.#{model_name.underscore}
RUBY
      end
    end

    def add_plural_relations
      if options[:parent] and options[:plural]
        model_name = (options[:child_synonym] or model)
        append_to_file "app/views/#{options[:parent].pluralize.underscore}/_#{options[:parent].underscore}.json.jbuilder", <<RUBY
json.#{model_name.pluralize.underscore} do
  json.array!(#{options[:parent].underscore}.#{model_name.pluralize.underscore}) do |#{model_name.underscore}|
    json.partial! "#{model.pluralize.underscore}/#{model.underscore}.json.jbuilder", #{model_name.underscore}: #{model_name.underscore}
  end
end
RUBY
      end
    end
  end
end
