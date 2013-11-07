require_relative 'test_helper'

module MongoidModelMaker
  class FactoriesTest < Rails::Generators::TestCase
    include MongoidModelMaker::TestUtils
    tests MongoidModelMaker::FactoriesGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "calls factory_girl generator correctly" do
      Rails::Generators.stubs(:invoke).with("factory_girl:model", "person first:string last:string")
      run_generator %w(person first:string last:string)
    end

    test "adds singular references in parent factory" do
      assert false
    end

    test "adds plural references in parent factory" do
      assert false
    end

    test "adds custom factory code" do
      assert false
    end

    test "reads stdin twice" do
      FactoriesGenerator.any_instance.stubs(:gets).returns("hello\n","world\n")
      run_generator %w(person)
      puts `tree`
      assert_file "hello", "hello\nworld"
    end
  end
end
