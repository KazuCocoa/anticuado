module Anticuado
  module IOS
    class CocoaPods
      def initialize
        @outdated = ""
      end

      def outdated
        @outdated = `pod outdated`
      end

      # @param [String] outdated The result of command `pod outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(outdated)
        array = outdated.split(/\R/)
        index = array.find_index("The following pod updates are available:")
        array[index + 1..array.size]
      end
    end # class CocoaPods
  end # module IOS
end # module Anticuado
