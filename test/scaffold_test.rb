require_relative 'test_helper'

module MongoidModelMaker
  class ScaffoldTest < Rails::Generators::TestCase
    tests MongoidModelMaker::ScaffoldGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "loads yaml file" do
      assert
    end
    test "run scaffolds" do
      Rails::Generators.stubs(:invoke).once.with( "scaffold", %w(person first:string last:string) )
      run_generator %w(test/fixtures/simple_model.yaml)
    end

  end
end
