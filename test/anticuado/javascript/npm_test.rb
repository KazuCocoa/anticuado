require 'test_helper'

module Anticuado
  module JavaScript
    class NpmTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED
      Package             Current  Wanted  Latest  Location
      babel-brunch          6.0.2   6.0.6   6.0.6
      clean-css-brunch      1.7.2   1.7.2   2.0.0
      uglify-js-brunch      1.7.8   1.7.8   2.0.1
      OUTDATED

      OUTDATED_NO_UPDATE =<<-OUTDATED
      Package             Current  Wanted  Latest  Location
      OUTDATED


      def test_with_format_have_update
        npm = Anticuado::JavaScript::Npm.new
        result = npm.format OUTDATED_HAVE_UPDATE

        expected_0 = { library_name: "babel-brunch", current_version: "6.0.2", available_version: "6.0.6", latest_version: "6.0.6" }
        expected_1 = { library_name: "clean-css-brunch", current_version: "1.7.2", available_version: "1.7.2", latest_version: "2.0.0" }
        expected_2 = { library_name: "uglify-js-brunch", current_version: "1.7.8", available_version: "1.7.8", latest_version: "2.0.1" }

        assert_equal OUTDATED_HAVE_UPDATE, npm.outdated_libraries

        assert_equal expected_0, result[0]
        assert_equal expected_1, npm.formatted_outdated_libraries[1]
        assert_equal expected_2, result[2]
        assert_nil result[3]
      end

      def test_with_format_no_update
        npm = Anticuado::JavaScript::Npm.new
        result = npm.format OUTDATED_NO_UPDATE

        assert_equal OUTDATED_NO_UPDATE, npm.outdated_libraries

        expected = []
        assert_equal expected, result
      end

    end
  end
end
