require 'test_helper'

module Anticuado
  module IOS
    class CarthageTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED
*** Fetching Result
*** Fetching Himotoki
The following dependencies are outdated:
Result "2.0.0" -> "2.1.3"
      OUTDATED

      OUTDATED_HAVE_UPDATE_WITH_LATEST =<<-OUTDATED
*** Fetching Puree-Swift
The following dependencies are outdated:
Puree-Swift "3.0.0" -> "3.0.0" (Latest: "3.1.1")
      OUTDATED

      OUTDATED_NO_UPDATE =<<-OUTDATED
*** Fetching Result
*** Fetching Himotoki
All dependencies are up to date.
      OUTDATED


      def test_with_format_have_update
        carthage = Anticuado::IOS::Carthage.new
        result = carthage.format OUTDATED_HAVE_UPDATE

        expected_0 = { library_name: "Result", current_version: "2.0.0", available_version: "2.1.3", latest_version: "2.1.3" }

        assert_equal OUTDATED_HAVE_UPDATE, carthage.outdated_libraries

        assert_equal expected_0, result[0]
        assert_equal expected_0, carthage.formatted_outdated_libraries[0]
      end

      def test_with_format_have_update_with_latest
        carthage = Anticuado::IOS::Carthage.new
        result = carthage.format OUTDATED_HAVE_UPDATE_WITH_LATEST

        expected_0 = { library_name: "Puree-Swift", current_version: "3.0.0", available_version: "3.0.0", latest_version: "3.1.1" }

        assert_equal OUTDATED_HAVE_UPDATE_WITH_LATEST, carthage.outdated_libraries

        assert_equal expected_0, result[0]
        assert_equal expected_0, carthage.formatted_outdated_libraries[0]
      end

      def test_with_format_no_update
        carthage = Anticuado::IOS::Carthage.new
        result = carthage.format OUTDATED_NO_UPDATE

        expected = []

        assert_equal OUTDATED_NO_UPDATE, carthage.outdated_libraries
        assert_equal expected, result
      end

    end
  end
end
