require 'test_helper'

module Anticuado
  module Ruby
    class BundlerTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED
Fetching gem metadata from https://rubygems.org/
Fetching version metadata from https://rubygems.org/
Resolving dependencies...

Outdated gems included in the bundle:
* google-protobuf (newest 3.1.0, installed 3.0.2)
* jwt (newest 1.5.6, installed 1.5.5)
      OUTDATED

      OUTDATED_NO_UPDATE =<<-OUTDATED
Fetching gem metadata from https://rubygems.org/
Fetching version metadata from https://rubygems.org/
Resolving dependencies...

Bundle up to date!
      OUTDATED

      def test_with_format_have_update
        result = Anticuado::Ruby::Bundler.format OUTDATED_HAVE_UPDATE

        expected_0 = { library_name: "google-protobuf", current_version: "3.0.2", available_version: "3.1.0", latest_version: "3.1.0" }
        expected_1 = { library_name: "jwt", current_version: "1.5.5", available_version: "1.5.6", latest_version: "1.5.6" }

        assert_equal expected_0, result[0]
        assert_equal expected_1, result[1]
        assert_nil result[2]
      end

      def test_with_format_no_update
        result = Anticuado::Ruby::Bundler.format OUTDATED_NO_UPDATE

        expected = []
        assert_equal expected, result
      end
    end
  end
end
