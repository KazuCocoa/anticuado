require 'test_helper'

module Anticuado
  module Java
    class GradleTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED

      OUTDATED

      OUTDATED_NO_UPDATE =<<-OUTDATED

      OUTDATED

      def test_with_format_have_update
        gradle = Anticuado::Java::Gradle.new

        json = gradle.parse_json "#{__dir__}/outdated_json.json"
        result = gradle.format json

        expected_0 = { group_name: "com.google.inject", library_name: "guice", current_version: "2.0",
                       available_version: "3.0", latest_version: "3.0" }
        expected_1 = { group_name: "com.google.inject.extensions", library_name: "guice-multibindings",
                       current_version: "2.0", available_version: "3.0", latest_version: "3.0" }

        assert_equal json, gradle.outdated_libraries

        assert_equal expected_0, result[0]
        assert_equal expected_1, gradle.formatted_outdated_libraries[1]
        assert_nil result[2]
        assert_equal 2, result.size
      end

      def test_with_format_no_update
        gradle = Anticuado::Java::Gradle.new

        json = gradle.parse_json "#{__dir__}/no_outdated_json.json"
        result = gradle.format json

        assert_equal json, gradle.outdated_libraries

        expected = []
        assert_equal expected, result
      end

    end
  end
end