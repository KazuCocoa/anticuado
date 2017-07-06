require 'test_helper'

module Anticuado
  module IOS
    class CocoaPodsTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED
Updating spec repo `master`
Performing a deep fetch of the `master` specs repo to improve future performance
Analyzing dependencies
The following pod updates are available:
- AFNetworking 2.5.4 -> 3.1.0 (latest version 3.1.0)
- OHHTTPStubs 4.1.0 -> 5.0.0 (latest version 5.0.0)

[!] CocoaPods was not able to update the `master` repo. If this is an unexpected issue and persists you can inspect it running `pod repo update --verbose`
      OUTDATED

      OUTDATED_NO_UPDATE =<<-OUTDATED
Updating spec repo `master`
Performing a deep fetch of the `master` specs repo to improve future performance
Analyzing dependencies
      OUTDATED


      def test_with_format_have_update
        result = Anticuado::IOS::CocoaPods.format OUTDATED_HAVE_UPDATE

        expected_0 = { library_name: "AFNetworking", current_version: "2.5.4", available_version: "3.1.0", latest_version: "3.1.0" }
        expected_1 = { library_name: "OHHTTPStubs", current_version: "4.1.0", available_version: "5.0.0", latest_version: "5.0.0" }

        assert_equal expected_0, result[0]
        assert_equal expected_1, result[1]
        assert_nil result[2]
      end

      def test_with_format_no_update
        result = Anticuado::IOS::CocoaPods.format OUTDATED_NO_UPDATE

        expected = []
        assert_equal expected, result
      end

      def test_no_update_cocoapod
        expected = File.read("test/anticuado/ios/cocoapod_actual")

        actual_file_path = "test/anticuado/ios/cocoapod_actual"
        actual_output_file_path = "test/anticuado/ios/cocoapod_actual_out"

        Anticuado::IOS::CocoaPods.update(pod_file_in: actual_file_path, pod_file_out: actual_output_file_path, libraries: {})

        actual = File.read(actual_output_file_path)

        assert_equal expected, actual

        File.delete(actual_output_file_path)
      end


      def test_with_update_cocoapod
        expected = File.read("test/anticuado/ios/cocoapod_expected1")

        actual_file_path = "test/anticuado/ios/cocoapod_actual"
        actual_output_file_path = "test/anticuado/ios/cocoapod_actual_out"

        Anticuado::IOS::CocoaPods.update(pod_file_in: actual_file_path, pod_file_out: actual_output_file_path, libraries: {"AFNetworking": "4.0"})

        actual = File.read(actual_output_file_path)

        assert_equal expected, actual

        File.delete(actual_output_file_path)
      end

      def test_with_update_cocoapod1
        expected = File.read("test/anticuado/ios/cocoapod_expected2")

        actual_file_path = "test/anticuado/ios/cocoapod_actual"
        actual_output_file_path = "test/anticuado/ios/cocoapod_actual_out"

        Anticuado::IOS::CocoaPods.update(pod_file_in: actual_file_path, pod_file_out: actual_output_file_path, libraries: {"AFNetworking": "4.0", "OHHTTPStubs": "4.2.0"})

        actual = File.read(actual_output_file_path)

        assert_equal expected, actual

        File.delete(actual_output_file_path)
      end
    end
  end
end
