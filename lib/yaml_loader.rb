require 'yaml'
require 'rails'

module MongoidModelMaker
  # TODO refactor the repetition occuring in all the run_* methods
  class Models
    attr_accessor :classes, :file

    # load yaml file
    def initialize yaml_filename
      @file = YAML::load_file( yaml_filename )
      #@classes = yaml_to_classes @file
    end

    # run scaffolds
    #   invokes scaffold generator many times
    def run_scaffolds
      @file.each_pair do |class_name, spec|
        args = []
        args << class_name 
        args += spec["fields"].map do |field|
          "#{field["name"]}:#{field["type"]}"
        end
        args << '--timestamps'
        Rails::Generators.invoke "rails:scaffold", args
      end
    end

    def run_relations
      @file.each_pair do |class_name, spec|
        if spec["relation"]
          args = ['--child=' + class_name]
          args << "--parent=#{spec["relation"]["parent"]}"
          args << "--relation=#{spec["relation"]["type"]}"
          args << "--child_synonym=#{spec["relation"]["synonym"]}" if spec["relation"]["synonym"]
          args << "--parent_validations=#{spec["relation"]["validation"].split("\n").join(';')}" if spec["relation"]["validation"]
          args << "--child_validations=#{spec["validation"].split("\n").join(';')}" if spec["validation"]
          Rails::Generators.invoke "mongoid_model_maker:relation", args
        elsif spec["validation"]
          raise NotImplementedError, "The relation generator currently doesn't support validations on models without a parent"
        end
      end
    end

    def run_factories
      @file.each_pair do |class_name, spec|
        args = [class_name]
        args += spec["fields"].map do |field|
          "#{field["name"]}:#{field["type"]}" + if field["factory"] then ":#{field["factory"].chomp}" else '' end
        end
        if spec["relation"]
          args << "--plural=#{%w(has_many embeds_many).include? spec["relation"]["type"]}" if spec["relation"]["type"]
          args << "--parent=#{spec["relation"]["parent"]}" if spec["relation"]["parent"]
          args << "--child_synonym=#{spec["relation"]["synonym"]}" if spec["relation"]["synonym"]
        end
        Rails::Generators.invoke "mongoid_model_maker:factory", args
      end
    end

    def run_jbuilders
      @file.each_pair do |class_name, spec|
        args = [class_name] 
        args += spec["fields"].map do |field|
          "#{field["name"]}:#{field["type"]}"
        end
        if spec["relation"]
          args << "--plural=#{%w(has_many embeds_many).include? spec["relation"]["type"]}" if spec["relation"]["type"]
          # if has a parent relation add it
          if parent_name = spec["relation"]["parent"]
            # if parent relation has a synonym add that also
            parent_synonym = @file[parent_name]["relation"]["synonym"] rescue nil
            args << "--parent=#{parent_name}"
            args << "--parent_synonym=#{parent_synonym}" if parent_synonym
          end
          args << "--child_synonym=#{spec["relation"]["synonym"]}" if spec["relation"]["synonym"]
        end
        Rails::Generators.invoke "mongoid_model_maker:j_builder", args
      end
    end

    def run_all
      run_scaffolds
      run_relations
      run_factories
      run_jbuilders
    end
  end
end
