require_relative 'test_helper'

module MongoidModelMaker
  class JBuilderTest < Rails::Generators::TestCase
    include MongoidModelMaker::TestUtils
    tests MongoidModelMaker::JBuilderGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "creates simple jbuilder partial" do
      @file_helper.vars = 
      { 
        model_name: "person",
        fields: %w(:first :last)
      }
      #@file_helper.template "view_partial.json.jbuilder.erb", "tmp/app/views/people/_person.json.jbuilder"
      run_generator %w(person first:string last:string)
      file_contents = <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
RUBY
      assert_file "app/views/people/_person.json.jbuilder", file_contents
    end
  end
end
