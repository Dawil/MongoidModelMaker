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
          Rails::Generators.invoke "mongoid_model_maker:relation", args
        end
      end
    end

    def run_factories
      @file.each_pair do |class_name, spec|
        args = [class_name]
        args += spec["fields"].map do |field|
          "#{field["name"]}:#{field["type"]}"
        end
        if spec["relation"]
          args << "--plural=#{%w(has_many embeds_many).include? spec["relation"]["type"]}" if spec["relation"]["type"]
          args << "--parent=#{spec["relation"]["parent"]}" if spec["relation"]["parent"]
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
          args << "--parent=#{spec["relation"]["parent"]}" if spec["relation"]["parent"]
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
