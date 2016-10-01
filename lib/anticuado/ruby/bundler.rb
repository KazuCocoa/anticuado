module Anticuado
  module Ruby
    module Bundler
      def self.outdated(project = nil)
        return "have no bundle command" if `which bundle`.empty?

        if project
          current_dir = Dir.pwd
          Dir.chdir project
          outdated_str = `bundle outdated`
          Dir.chdir current_dir
        else
          outdated_str = `bundle outdated`
        end
        outdated_str
      end

      # @param [String] outdated The result of command `bundle outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def self.format(outdated)
        array = outdated.split(/\R/)
        index = array.find_index("Outdated gems included in the bundle:")

        return [] if index.nil?

        array[index + 1..array.size].map { |library|
          versions = library.split(/\s/) # e.g. ["*", "jwt", "(newest", "1.5.6,", "installed", "1.5.5)"]
          if versions[0] == "*"
            {
                library_name: versions[1],
                current_version: versions[5].delete(")"),
                available_version: versions[3].delete(","),
                latest_version: versions[3].delete(",")
            }
          end
        }.compact
      end
    end # module Bundler
  end # module Ruby
end # module Anticuado
