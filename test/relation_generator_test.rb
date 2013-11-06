require_relative 'test_helper'

module MongoidModelMaker
  class RelationTest < Rails::Generators::TestCase
    tests MongoidModelMaker::RelationGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    def setup
      @file_helper = MongoidModelMaker::FileHelper.new
    end

    test "adds relation type to child model" do
      @file_helper.vars = 
      { 
        model_name: "Dog",
        fields: { name: "String", breed: "String" }
      }
      @file_helper.template "model.erb", "tmp/app/models/dog.rb"
      puts `cat tmp/app/models/dog.rb`
      run_generator %w(--child=dog --parent=person --relation=embeds_one)
      assert_file "tmp/app/models/dog.rb", "embedded_in :person"
    end

    #test "adds relation type to parent model" do
    #  run_generator %w(--child=dog --parent=person --relation=has_one)
    #end

  end
end
