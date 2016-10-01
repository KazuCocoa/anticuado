module Anticuado
  module IOS
    module Carthage
      # @param [String] project Path to project directory.
      # @return [String] The result of command `carthage outdated`.
      def self.outdated(project: nil)
        return puts "have no carthage command" if `which carthage`.empty?

        if project
          `carthage outdated --project-directory #{project}`
        else
          `carthage outdated`
        end
      end

      # @param [String] outdated The result of command `carthage outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def self.format(outdated)
        array = outdated.split(/\R/)
        index = array.find_index("The following dependencies are outdated:")

        return [] if index.nil?

        array[index + 1..array.size].map do |library|
          versions = library.split(/[\s|"]/) # e.g. ["Result", "", "2.0.0", "", "->", "", "2.1.3"]
          {
              library_name: versions[0],
              current_version: versions[2],
              available_version: versions[6],
              latest_version: versions[6]
          }
        end
      end
    end # module Carthage
  end # module IOS
end # module Anticuado
