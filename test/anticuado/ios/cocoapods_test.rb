require 'test_helper'

module Anticuado
  module IOS
    class CocoaPodsTest < Minitest::Test

      OUTDATED =<<-OUTDATED
Updating spec repo `master`
Performing a deep fetch of the `master` specs repo to improve future performance
Analyzing dependencies
The following pod updates are available:
- AFNetworking 2.5.4 -> 3.1.0 (latest version 3.1.0)
- OHHTTPStubs 4.1.0 -> 5.0.0 (latest version 5.0.0)
      OUTDATED

      def test_with_format
        cocoapods = Anticuado::IOS::CocoaPods.new
        result = cocoapods.format OUTDATED

        assert_equal "- AFNetworking 2.5.4 -> 3.1.0 (latest version 3.1.0)", result[0]
        assert_equal "- OHHTTPStubs 4.1.0 -> 5.0.0 (latest version 5.0.0)", result[1]
      end
    end
  end
end