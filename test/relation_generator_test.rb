require_relative 'test_helper'

module MongoidModelMaker
  class RelationTest < Rails::Generators::TestCase
    include MongoidModelMaker::TestUtils
    tests MongoidModelMaker::RelationGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    def create_double_models
      # TODO: refactor this template initialization code
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

    test "adds plural relation to parent model" do
      create_double_models
      run_generator %w(--child=dog --parent=person --relation=embeds_many)
      assert_file "app/models/person.rb", /embeds_many :dogs/
      assert_file "app/models/person.rb", /accepts_nested_attributes_for :dogs/
    end

    test "adds correct synonym" do
      create_double_models
      run_generator %w(--child=dog --parent=person --relation=embeds_one --child_synonym=doggie)
      assert_file "app/models/dog.rb", /embedded_in :person, inverse_of: :doggie/
      assert_file "app/models/person.rb", /embeds_one :doggie, class_name: 'Dog'/
    end

    test "adds validations for the child relation" do
      create_double_models
      puts run_generator %w(--child=dog --parent=person --relation=embeds_one) + ["--child_validations=validates_presence_of :name;validates_presence_of :breed\n"]
      assert_file "app/models/dog.rb", /validates_presence_of :name/
      assert_file "app/models/dog.rb", /validates_presence_of :breed/
      puts `cat tmp/app/models/dog.rb`
    end

    test "adds validations for the parent relation" do
      create_double_models
      run_generator %w(--child=dog --parent=person --relation=embeds_one) + ['--parent_validations=validate_presence_of :dog']
      assert_file "app/models/person.rb", /validate_presence_of :dog/
      puts `cat tmp/app/models/person.rb`
    end
  end
end
