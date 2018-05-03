require 'test_helper'

module Anticuado
  module Elixir
    class HexTest < Minitest::Test

      OUTDATED_HAVE_UPDATE =<<-OUTDATED
Dependency           Current  Latest  Requirement
cowboy               1.0.4    1.0.4   ~> 1.0
credo                0.4.11   0.4.11  ~> 0.3
dialyxir             0.3.5    0.3.5   ~> 0.3.5
gettext              0.11.0   0.11.0  ~> 0.9
hound                1.0.2    1.0.2   ~> 1.0
logger_file_backend  0.0.8    0.0.9   ~> 0.0
nimble_csv           0.1.0    0.1.0   ~> 0.1.0
phoenix              1.2.1    1.2.1   ~> 1.2.0
phoenix_ecto         3.0.1    3.0.1   ~> 3.0
phoenix_haml         0.2.2    0.2.2   ~> 0.2
phoenix_live_reload  1.0.5    1.0.5   ~> 1.0
phoenix_pubsub       1.0.0    1.0.0   ~> 1.0
postgrex             0.11.2   0.12.0  ~> 0.11.2
revision_plate_ex    0.2.0    0.2.0   ~> 0.2

A green version in latest means you have the latest version of a given package. A green requirement means your current requirement matches the latest version.
      OUTDATED

      OUTDATED_HAVE_UPDATE_015 =<<-OUTDATED
Dependency        Current  Latest  Update possible
cowboy            1.0.4    1.0.4
credo             0.5.3    0.5.3
dialyxir          0.4.0    0.4.1   Yes
earmark           1.0.3    1.0.3
ex_doc            0.14.4   0.14.5  Yes
excoveralls       0.5.7    0.5.7
exjsx             3.2.1    3.2.1
exvcr             0.8.4    0.8.4
plug              1.3.0    1.3.0
shouldi           0.3.2    0.3.2
      OUTDATED

      OUTDATED_NO_UPDATE =<<-OUTDATED
A new Hex version is available (0.13.2), please update with `mix local.hex`
Dependency           Current  Latest  Requirement
cowboy               1.0.4    1.0.4   ~> 1.0
dialyxir             0.3.5    0.3.5   ~> 0.3.5
gettext              0.11.0   0.11.0  ~> 0.9
hound                1.0.2    1.0.2   ~> 1.0
nimble_csv           0.1.0    0.1.0   ~> 0.1.0
phoenix              1.2.1    1.2.1   ~> 1.2.0
phoenix_ecto         3.0.1    3.0.1   ~> 3.0
phoenix_haml         0.2.2    0.2.2   ~> 0.2
phoenix_live_reload  1.0.5    1.0.5   ~> 1.0
phoenix_pubsub       1.0.0    1.0.0   ~> 1.0
revision_plate_ex    0.2.0    0.2.0   ~> 0.2
      OUTDATED

      def test_with_format_have_update
        hex = Anticuado::Elixir::Hex.new
        result = hex.format OUTDATED_HAVE_UPDATE

        expected_0 = { library_name: "logger_file_backend", current_version: "0.0.8", available_version: "0.0.9", latest_version: "0.0.9" }
        expected_1 = { library_name: "postgrex", current_version: "0.11.2", available_version: "0.12.0", latest_version: "0.12.0" }

        assert_equal OUTDATED_HAVE_UPDATE, hex.outdated_libraries

        assert_equal expected_0, result[0]
        assert_equal expected_1, hex.formatted_outdated_libraries[1]
        assert_nil result[2]
      end

      def test_with_format_have_update_015
        hex = Anticuado::Elixir::Hex.new
        result = hex.format OUTDATED_HAVE_UPDATE_015

        expected_0 = { library_name: "dialyxir", current_version: "0.4.0", available_version: "0.4.1", latest_version: "0.4.1" }
        expected_1 = { library_name: "ex_doc", current_version: "0.14.4", available_version: "0.14.5", latest_version: "0.14.5" }

        assert_equal OUTDATED_HAVE_UPDATE_015, hex.outdated_libraries

        assert_equal expected_0, result[0]
        assert_equal expected_1, hex.formatted_outdated_libraries[1]
        assert_nil result[2]
      end

      def test_with_format_no_update
        hex = Anticuado::Elixir::Hex.new
        result = hex.format OUTDATED_NO_UPDATE

        expected = []

        assert_equal OUTDATED_NO_UPDATE, hex.outdated_libraries

        assert_equal expected, result
      end
    end
  end
end