require 'rails'
require 'rails/generators'

module MongoidModelMaker
  class RelationGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :parent_class, type: :string, required: true, desc: "An optional parent class for mongoid relations"
    class_option :relation_type, type: :string, required: true, desc: "Type of mongoid relation"
    class_option :class_synonym, type: :string, default: nil, desc: "An alternative name to reference the model by"

    def main
      unless valid_relations.include? relation_type
        raise ArgumentError, "Invalid relation type: #{relation_type}"
      end

  #    invoke :scaffold
  #    routes_relation
      model_relation
      view_relation
      factories_relation
    end

  private
    def routes_relation
      gsub_file 'config/routes.rb', "resources :#{name.pluralize.underscore}", ''
      gsub_file 'config/routes.rb', "  resources :#{parent_class.pluralize.underscore}\n" do
<<RUBY
  resources :#{parent_class.pluralize.underscore} do
  end
RUBY
      end

      inject_into_file 'config/routes.rb', after: "resources :#{parent_class.pluralize.underscore} do\n" do
<<RUBY
    resources :#{name.pluralize.underscore}
RUBY
      end
    end

    def model_relation
      include_text = "include Mongoid::Timestamps\n"
      n = child_name
      n = n.pluralize if relation_type == "embeds_many"

      inject_into_file "app/models/#{parent_class.underscore}.rb", after: include_text do
<<RUBY

  #{relation_type} :#{n.underscore}#{", class_name: '#{name.camelize}'" if options.class_synonym}

  accepts_nested_attributes_for :#{n.underscore}
RUBY
      end
      inject_into_file "app/models/#{name.underscore}.rb", after: include_text do
<<RUBY

  embedded_in :#{parent_class.underscore}#{", inverse_of: :#{n.underscore}" if options.class_synonym}

RUBY
      end
    end

    def view_relation
      #html_relation
      json_relation
    end

    def html_relation
    end

    def json_relation
      template '_model.json.jbuilder.erb', "app/views/#{name.pluralize.underscore}/_#{name.underscore}.json.jbuilder"
      partial_file = "app/views/#{parent_class.pluralize.underscore}/_#{parent_class.underscore}.json.jbuilder"
      create_file partial_file unless File.exists? partial_file
      append_to_file partial_file do
        if relation_type == "embeds_one"
<<RUBY
json.#{child_name.underscore} do
  json.partial! '#{name.pluralize.underscore}/#{name.underscore}.json.jbuilder', #{child_name.underscore}: #{parent_class.underscore}.#{child_name.underscore}
end if #{parent_class.underscore}.#{child_name.underscore}
RUBY
        elsif relation_type == "embeds_many"
<<RUBY
json.#{child_name.pluralize.underscore} do
  json.array!(#{parent_class.underscore}.#{child_name.pluralize.underscore}) do |#{child_name.underscore}|
    json.partial! '#{name.pluralize.underscore}/#{name.underscore}.json.jbuilder', #{child_name.underscore}: #{child_name.underscore}
  end
end
RUBY
        end
      end
    end

    def factories_relation
      inject_into_file "spec/factories/#{parent_class.pluralize.underscore}.rb", after: "factory :#{parent_class.underscore} do\n" do
        if relation_type == "embeds_one"
<<RUBY
    #{child_name.underscore} { FactoryGirl.build( :#{name.underscore} ) }
RUBY
        elsif relation_type == "embeds_many"
<<RUBY
    after(:create) do |#{parent_class.underscore}|
      FactoryGirl.create_list(:#{name.underscore}, 3, #{parent_class.underscore}: #{parent_class.underscore})
    end
RUBY
        end
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
      options.parent_class
    end

    # no guarrantees are made about the user's format
    # always assume you have to specify .camelize or .underscore
    def child_name
      options.class_synonym or name
    end
  end
end
