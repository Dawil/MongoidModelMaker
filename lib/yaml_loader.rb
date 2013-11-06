require 'yaml'
require 'rails'

module MongoidModelMaker
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
    # run relations
    #   invokes relation generator many times
    def run_relations
    end
    # run factories
    #   invokes factory generator many times
    def run_factories
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
