namespace :mmm do
  task :load_yml_file, [:yml_file] do |t, args|
    puts t, args
    puts "Loading yml file: #{args.yml_file}"
  end

  desc "Generate model files from yaml specification."
  task :models, [:yml_file] => :load_yml_file do
    puts "Generating models"
  end

  desc "Add relations to model files."
  task :relations, [:yml_file] => :load_yml_file do
    puts "Adding relations to models"
  end

  desc "Add factory code to factories."
  task :factories, [:yml_file] => :load_yml_file do
    puts "Extending factories"
  end

  desc "Use Graphviz to create a visualization."
  task :visualize, [:yml_file] => :load_yml_file do
    puts "Creating visualization"
  end
end
