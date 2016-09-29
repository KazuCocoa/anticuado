module Anticuado
  module IOS
    module CocoaPods
      def self.outdated
        return "" if `which pod`.empty?
        `pod outdated`
      end

      # @param [String] outdated The result of command `pod outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def self.format(outdated)
        array = outdated.split(/\R/)
        index = array.find_index("The following pod updates are available:")

        return [] if index.nil?

        array[index + 1..array.size].map do |library|
          versions = library.split(/\s/) # e.g. ["-", "AFNetworking", "2.5.4", "->", "3.1.0", "(latest", "version", "3.1.0)"]
          {
              library_name: versions[1],
              current_version: versions[2],
              available_version: versions[4],
              latest_version: versions[7].delete(")")
          }
        end
      end
    end # module CocoaPods
  end # module IOS
end # module Anticuado
