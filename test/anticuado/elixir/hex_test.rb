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
        result = Anticuado::Elixir::Hex.format OUTDATED_HAVE_UPDATE

        expected_0 = { library_name: "logger_file_backend", current_version: "0.0.8", available_version: "0.0.9", latest_version: "0.0.9" }
        expected_1 = { library_name: "postgrex", current_version: "0.11.2", available_version: "0.12.0", latest_version: "0.12.0" }

        assert_equal expected_0, result[0]
        assert_equal expected_1, result[1]
        assert_nil result[2]
      end

      def test_with_format_no_update
        result = Anticuado::Elixir::Hex.format OUTDATED_NO_UPDATE

        expected = []
        assert_equal expected, result
      end
    end
  end
end