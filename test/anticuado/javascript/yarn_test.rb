require 'test_helper'

module Anticuado
  module JavaScript
    class YarnTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED
      \e[2K\e[1GPackage Current Wanted Latest
      react   0.14.8  0.14.8 15.3.2
      \e[2K\e[1G  Done in 0.72s.
      OUTDATED
      OUTDATED_NO_UPDATE =<<-OUTDATED
      \e[2K\e[1Gyarn outdated v0.15.1\n\e[2K\e[1GDone in 1.36s.\n
      OUTDATED


      def test_with_format_have_update
        yarn = Anticuado::JavaScript::Yarn.new
        result = yarn.format OUTDATED_HAVE_UPDATE

        expected_0 = { library_name: "react", current_version: "0.14.8", available_version: "0.14.8", latest_version: "15.3.2" }

        assert_equal expected_0, result[0]
        assert_equal expected_0, yarn.formatted_outdated_libraries[0]
        assert_nil result[1]
      end

      def test_with_format_no_update
        yarn = Anticuado::JavaScript::Yarn.new
        result = yarn.format OUTDATED_NO_UPDATE

        assert_equal OUTDATED_NO_UPDATE, yarn.outdated_libraries

        expected = []
        assert_equal expected, result
      end

    end
  end
end
