require_relative 'test_helper'

module MongoidModelMaker
  class JBuilderTest < Rails::Generators::TestCase
    include MongoidModelMaker::TestUtils
    tests MongoidModelMaker::JBuilderGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "creates simple jbuilder partial" do
      run_generator %w(person first:string last:string)
      file_contents = <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
RUBY
      assert_file "app/views/people/_person.json.jbuilder", file_contents
    end

    test "creates simple jbuilder partial with child synonym" do
      run_generator %w(person first:string last:string --child_synonym=peep)
      file_contents = <<RUBY
json.id peep.id
json.extract! peep, :created_at, :updated_at, :first, :last
RUBY
      assert_file "app/views/people/_person.json.jbuilder", file_contents
    end

    test "calls partial from index page" do
      @file_helper.create_file "tmp/app/views/people/index.json.jbuilder", <<RUBY
json.array!(@people) do |person|
  json.extract! person, :first, :last
  json.url person_url(person, format: :json)
end
RUBY
      run_generator %w(person first:string last:string)
      assert_file "app/views/people/index.json.jbuilder", <<RUBY
json.array!(@people) do |person|
  json.partial! "people/person.json.jbuilder", person: person
end
RUBY
    end

    test "calls partial from show page" do
      @file_helper.create_file "tmp/app/views/people/show.json.jbuilder", <<RUBY
json.extract! @person, :created_at, :updated_at, :first, :last
RUBY
      run_generator %w(person first:string last:string)
      assert_file "app/views/people/show.json.jbuilder", <<RUBY
json.partial! "people/person.json.jbuilder", person: @person
RUBY
    end

    test "adds a singular reference to partial in parent" do
      @file_helper.create_file "tmp/app/views/people/_person.json.jbuilder", <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
RUBY
      run_generator %w(dog name:string breed:string --parent=person)
      assert_file "app/views/people/_person.json.jbuilder",  <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
json.dog do
  json.partial! "app/views/dogs/dog.json.jbuilder", dog: person.dog
end if person.dog
RUBY
    end

    test "adds a singular reference to partial in parent with child synonym" do
      @file_helper.create_file "tmp/app/views/people/_person.json.jbuilder", <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
RUBY
      run_generator %w(dog name:string breed:string --parent=person --child_synonym=doggie)
      assert_file "app/views/people/_person.json.jbuilder",  <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
json.doggie do
  json.partial! "app/views/dogs/dog.json.jbuilder", doggie: person.doggie
end if person.doggie
RUBY
    end

    test "adds a plural reference to partial in parent" do
      @file_helper.create_file "tmp/app/views/people/_person.json.jbuilder", <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
RUBY
      run_generator %w(dog name:string breed:string --parent=person --plural=true)
      assert_file "app/views/people/_person.json.jbuilder",  <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
json.dogs do
  json.array!(person.dogs) do |dog|
    json.partial! "app/views/dogs/dog.json.jbuilder", dog: dog
  end
end
RUBY
    end

    test "adds a plural reference to partial in parent with child synonym" do
      @file_helper.create_file "tmp/app/views/people/_person.json.jbuilder", <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
RUBY
      run_generator %w(dog name:string breed:string --parent=person --plural=true --child_synonym=doggie)
      assert_file "app/views/people/_person.json.jbuilder",  <<RUBY
json.id person.id
json.extract! person, :created_at, :updated_at, :first, :last
json.doggies do
  json.array!(person.doggies) do |doggie|
    json.partial! "app/views/dogs/dog.json.jbuilder", doggie: doggie
  end
end
RUBY
    end
  end
end
