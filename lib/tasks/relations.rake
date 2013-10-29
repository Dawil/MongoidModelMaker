namespace :relations do
  task :load_yml_file, [:yml_file] do
    puts "Loading yml file: #{args.yml_file}"
  end

  task models: [:load_yml_file] do
    puts "Generating models"
  end
end
