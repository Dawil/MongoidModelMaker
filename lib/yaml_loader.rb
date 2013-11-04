require 'yaml'

module MongoidModelMaker
  class Models
    attr_accessor :classes

    def initialize yaml_filename
      file = YAML::load_file( yaml_filename )
      puts file
    end
  end
end
