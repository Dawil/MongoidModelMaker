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
        args = class_name + ' ' + spec["fields"].map do |field|
          "#{field["name"]}:#{field["type"]}"
        end.join(' ') + ' --timestamps'
        Rails::Generators.invoke "scaffold", args
      end
    end

    def run_relations
      @file.each_pair do |class_name, spec|
        if spec["relation"]
          args = class_name
          args += " --parent=#{spec["relation"]["parent"]}"
          args += " --relation=#{spec["relation"]["type"]}"
          Rails::Generators.invoke "relations", args
        end
      end
    end

    def run_factories
      @file.each_pair do |class_name, spec|
        args = class_name + ' ' + spec["fields"].map do |field|
          "#{field["name"]}:#{field["type"]}"
        end.join(' ')
        if spec["relation"]
          args += " --plural=#{%w(has_many embeds_many).include? spec["relation"]["type"]}" if spec["relation"]["type"]
          args += " --parent=#{spec["relation"]["parent"]}" if spec["relation"]["parent"]
        end
        Rails::Generators.invoke "factories", args
      end
    end

    def run_jbuilders
      @file.each_pair do |class_name, spec|
        args = class_name + ' ' + spec["fields"].map do |field|
          "#{field["name"]}:#{field["type"]}"
        end.join(' ')
        if spec["relation"]
          args += " --plural=#{%w(has_many embeds_many).include? spec["relation"]["type"]}" if spec["relation"]["type"]
          args += " --parent=#{spec["relation"]["parent"]}" if spec["relation"]["parent"]
        end
        Rails::Generators.invoke "jbuilder", args
      end
    end

    def run_all
      run_scaffolds
      run_relations
      run_factories
      run_jbuilders
    end
  private
    # create model representation
    def yaml_to_classes file_hash
      # add the top level classes
      classes = {}
      file_hash.find_all(&:without_parents).each_pair do |class_name,spec|
      end
      # add the immediate children classes until they're all gone
    end

    def without_parents class_def
      class_def["relation"].nil?
    end
  end
end
