module Anticuado
  module JavaScript
    class Yarn < Anticuado::Base
      # @return [String] The result of command `yarn outdated`.
      def outdated
        return puts "have no yarn command" if `which yarn`.empty?

        if @project_dir
          Dir.chdir(@project_dir) do
            @outdated_libraries = run_outdated
          end
        else
          @outdated_libraries = run_outdated
        end
        @outdated_libraries
      end

      # @param [String] outdated The result of command `yarn outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(outdated = nil)
        @outdated_libraries = outdated unless outdated.nil?

        array = @outdated_libraries.split(/\R/).map(&:strip)
        index = array.find_index { |line| line.scan(/Package\s+Current\s+Wanted\s+Latest/) != [] }

        return [] if index.nil?

        @formatted_outdated_libraries = array[index + 1...(array.size - 1)].map do |library|
          versions = library.split(/\s+/) # e.g. ["babel-brunch", "6.0.2", "6.0.6", "6.0.6"]
          {
              library_name: versions[0],
              current_version: versions[1],
              available_version: versions[2],
              latest_version: versions[3]
          }
        end
      end

      private

      def run_outdated
        `yarn install`
        `yarn outdated`
      end
    end # class Yarn
  end # module JavaScript
end # module Anticuado
