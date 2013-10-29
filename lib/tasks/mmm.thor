require 'thor'

module MongoidModelMaker
  class Tasks < Thor
    def load_yml_file(yml_file)
      puts t, args
      puts "Loading yml file: #{yml_file}"
    end

    desc "stuff", "yeah"
    def models
      puts "Generating models"
    end

    def relations
      puts "Adding relations to models"
    end

    def factories
      puts "Extending factories"
    end

    def visualize
      puts "Creating visualization"
    end
  end
end
