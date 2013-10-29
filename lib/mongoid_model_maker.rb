require "version"

module MongoidModelMaker
  class MyRailtie < Rails::Railtie
    rake_tasks do
      load "tasks/*.rake"
    end
  end
end
