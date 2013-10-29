require "bundler/gem_tasks"
namespace :relations do
  task :load_yml_file, [:yml_file] do |t, args|
    puts t, args
    puts "Loading yml file: #{args.yml_file}"
  end

  task :models, [:yml_file] => :load_yml_file do
    puts "Generating models"
  end
end
