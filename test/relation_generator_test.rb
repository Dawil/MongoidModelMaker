require_relative 'test_helper'

module MongoidModelMaker
  class RelationTest < Rails::Generators::TestCase
    tests MongoidModelMaker::RelationGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    def setup
      @file_helper = MongoidModelMaker::FileHelper.new
    end

    def create_double_models
      @file_helper.vars = 
      { 
        model_name: "Dog",
        fields: { name: "String", breed: "String" }
      }
      @file_helper.template "model.erb", "tmp/app/models/dog.rb"
      @file_helper.vars =
      {
        model_name: "Person",
        fields: { first: "String", last: "String" }
      }
      @file_helper.template "model.erb", "tmp/app/models/person.rb"
    end

    test "adds relation type to child model" do
      create_double_models
      run_generator %w(--child=dog --parent=person --relation=embeds_one)
      assert_file "app/models/dog.rb", /embedded_in :person/
    end

    test "adds relation type to parent model" do
      create_double_models
      run_generator %w(--child=dog --parent=person --relation=embeds_one)
      assert_file "app/models/person.rb", /embeds_one :dog/
      assert_file "app/models/person.rb", /accepts_nested_attributes_for :dog/
    end

  end
end
