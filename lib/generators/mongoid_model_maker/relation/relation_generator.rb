require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class RelationGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :child, type: :string, required: true, desc: "Child class for mongoid relation"
    class_option :parent, type: :string, required: true, desc: "Parent class for mongoid relation"
    class_option :relation, type: :string, required: true, desc: "Type of mongoid relation"
    class_option :child_synonym, type: :string, default: nil, desc: "An alternative name to reference the model by"
    class_option :child_validations, type: :string, default: "", desc: "Any validations for the child model as an escaped string"
    class_option :parent_validations, type: :string, default: "", desc: "Any validations for the parent model as an escaped string"

    def main
      unless valid_relations.include? options[:relation]
        raise ArgumentError, "Invalid relation type: #{options[:relation]}"
      end

      model_relation
    end

  private
    def model_relation
      include_text = "include Mongoid::Timestamps\n"
      n = (options[:child_synonym] or options[:child])
      n = n.pluralize if options[:relation] == "embeds_many"

      # nested attributes
      inject_into_file "app/models/#{options[:parent].underscore}.rb", after: include_text do
      <<-RUBY.gsub(/^#{'  ' * 3}/,'')

        #{options[:relation]} :#{n.underscore}#{", class_name: '#{options[:child].camelize}'" if options[:child_synonym]}

        accepts_nested_attributes_for :#{n.underscore}
      RUBY
      end

      # embedded
      inject_into_file "app/models/#{options[:child].underscore}.rb", after: include_text do
      <<-RUBY.gsub(/^#{'  ' * 3}/,'')

        embedded_in :#{options[:parent].underscore}#{", inverse_of: :#{n.underscore}" if options[:child_synonym]}

      RUBY
      end

      # validations
      inject_into_file "app/models/#{options[:child].underscore}.rb", after: include_text do
        "\n" + options[:child_validations].split(';').join("\n") + "\n"
      end
      inject_into_file "app/models/#{options[:parent].underscore}.rb", after: include_text do
        "\n" + options[:parent_validations].split(';').join("\n") + "\n"
      end
    end

    def valid_relations
      %w(has_one has_many embeds_one embeds_many)
    end

    def relation_type
      options.relation_type
    end

    # no guarrantees are made about the user's format
    # always assume you have to specify .camelize or .underscore
    def parent_class
      options.parent
    end

    # no guarrantees are made about the user's format
    # always assume you have to specify .camelize or .underscore
    def child_name
      options.child_synonym or options.child
    end
  end
end
