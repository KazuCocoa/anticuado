require 'test_helper'

module Anticuado
  module Java
    class GradleTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED

      OUTDATED

      OUTDATED_NO_UPDATE =<<-OUTDATED

      OUTDATED

      def test_with_format_have_update
        json = Anticuado::Java::Gradle.parse_json "#{__dir__}/outdated_json.json"
        result = Anticuado::Java::Gradle.format json

        expected_0 = { library_name: "guice", current_version: "2.0", available_version: "3.0", latest_version: "3.0" }
        expected_1 = { library_name: "guice-multibindings", current_version: "2.0", available_version: "3.0", latest_version: "3.0" }

        assert_equal expected_0, result[0]
        assert_equal expected_1, result[1]
        assert_nil result[2]
      end

      def test_with_format_no_update
        json = Anticuado::Java::Gradle.parse_json "#{__dir__}/no_outdated_json.json"
        result = Anticuado::Java::Gradle.format json

        expected = []
        assert_equal expected, result
      end

    end
  end
end