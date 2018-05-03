module Anticuado
  module IOS
    class Carthage < Anticuado::Base
      # @return [String] The result of command `carthage outdated`.
      def outdated
        return puts "have no carthage command" if `which carthage`.empty?

        @outdated_libraries = if @project_dir
                                `carthage outdated --project-directory #{@project_dir}`
                              else
                                `carthage outdated`
                              end
      end

      # @param [String] outdated The result of command `carthage outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(outdated = nil)
        @outdated_libraries = outdated unless outdated.nil?

        array = @outdated_libraries.split(/\R/).map(&:strip)
        index = array.find_index("The following dependencies are outdated:")

        return [] if index.nil?

        @formatted_outdated_libraries = array[index + 1..array.size].map do |library|
          versions = library.split(/[\s|"]/) 
          if versions[8] =~ /Latest/
            # e.g. ["RxSwift", "", "4.1.0", "", "->", "", "4.1.2", "", "(Latest:", "", "4.1.2", ")"]
            {
              library_name: versions[0],
              current_version: versions[2],
              available_version: versions[6],
              latest_version: versions[10]
            }
          else
            # e.g. ["Result", "", "2.0.0", "", "->", "", "2.1.3"]
            {
              library_name: versions[0],
              current_version: versions[2],
              available_version: versions[6],
              latest_version: versions[6]
            }
          end
        end
      end
    end # class Carthage
  end # module IOS
end # module Anticuado
