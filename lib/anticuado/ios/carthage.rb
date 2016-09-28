module Anticuado
  module IOS
    class Carthage
      def initialize
        @outdated = ""
      end

      def outdated
        @outdated = `carthage outdated`
      end

      # @param [String] outdated The result of command `carthage outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(outdated)
        outdated.each_line.map { |line|
          # do something
        }
      end
    end # class Carthage
  end # module IOS
end # module Anticuado
