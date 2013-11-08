require_relative 'test_helper'

module MongoidModelMaker
  class FactoriesTest < Rails::Generators::TestCase
    include MongoidModelMaker::TestUtils
    tests MongoidModelMaker::FactoryGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "calls factory_girl generator correctly" do
      Rails::Generators.stubs(:invoke).once.with( "factory_girl:model", %w(person first:string last:string) )
      run_generator %w(person first:string last:string)
    end

    test "adds singular references in parent factory" do
      @file_helper.create_file "tmp/spec/factories/person.rb", <<RUBY
FactoryGirl.define do
  factory :person do
    first "MyString"
    last "MyString"
  end
end
RUBY
      Rails::Generators.stubs(:invoke).once
      run_generator %w(dog name:string breed:string --parent=person)
      assert_file "spec/factories/person.rb", <<RUBY
FactoryGirl.define do
  factory :person do
    dog { FactoryGirl.build( :dog ) }
    first "MyString"
    last "MyString"
  end
end
RUBY
    end

    test "adds plural references in parent factory" do
      @file_helper.create_file "tmp/spec/factories/person.rb", <<RUBY
FactoryGirl.define do
  factory :person do
    first "MyString"
    last "MyString"
  end
end
RUBY
      Rails::Generators.stubs(:invoke).once
      run_generator %w(dog name:string breed:string --parent=person --plural=true)
      assert_file "spec/factories/person.rb", <<RUBY
FactoryGirl.define do
  factory :person do
    after(:create) do |person|
      FactoryGirl.create_list( :dog, 3, person: person )
    end
    first "MyString"
    last "MyString"
  end
end
RUBY
    end

    test "adds custom factory code" do
      FactoryGenerator.any_instance.stubs(:gets)
        .returns("{ Faker::Name.first_name }\n", "{ Faker::Name.last_name }\n")
      @file_helper.create_file "tmp/spec/factories/person.rb", <<RUBY
FactoryGirl.define do
  factory :person do
    first "MyString"
    last "MyString"
  end
end
RUBY
      Rails::Generators.stubs(:invoke).once
      run_generator %w(person first:string last:string --read_factories=true)
      assert_file "spec/factories/person.rb", <<RUBY
FactoryGirl.define do
  factory :person do
    first { Faker::Name.first_name }
    last { Faker::Name.last_name }
  end
end
RUBY
    end
  end
end
