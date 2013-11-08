require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class FactoryGenerator < Rails::Generators::Base
    argument :model, type: :string, required: true, desc: "Name of model"
    argument :fields, type: :array, required: false, desc: "List of space separated pairs, colon separated, of field name and field type"
    class_option :parent, type: :string, required: false, desc: "Name of parent model"
    # TODO instead of plural, it should be relation_type, and infer plurality
    class_option :plural, type: :boolean, required: false, desc: "Type of parent model relationship"

    def call_factory_girl_generator
      Rails::Generators.invoke "factory_girl:model", [model, fields, '--dir=spec'].flatten
    end

    def add_singular_references_in_parent_factory
      if options[:parent] and not options[:plural]
        after_text = "factory :#{options[:parent].underscore} do\n"
        inject_into_file "spec/factories/#{options[:parent].pluralize.underscore}.rb", after: after_text do
<<RUBY
    #{model.underscore} { FactoryGirl.build( :#{model.underscore} ) }
RUBY
        end
      end
    end

    def add_plural_references_in_parent_factory
      if options[:parent] and options[:plural]
        after_text = "factory :#{options[:parent].underscore} do\n"
        inject_into_file "spec/factories/#{options[:parent].pluralize.underscore}.rb", after: after_text do
<<RUBY
    after(:create) do |#{options[:parent].underscore}|
      FactoryGirl.create_list( :#{model.underscore}, 3, #{options[:parent].underscore}: #{options[:parent].underscore} )
    end
RUBY
        end
      end
    end

    def add_custom_factory_code
      fields.each do |field|
        field_name, field_type = field.split(':')
        factory_code = field.split(':')[2..-1].join(':')
        if factory_code != ""
          field_factory_code = "#{field_name} #{factory_code}"
          line_to_replace = /#{field_name} .*$/
          gsub_file "spec/factories/#{model.pluralize.underscore}.rb", line_to_replace do
            field_factory_code
          end
        end
      end
    end

  end
end
