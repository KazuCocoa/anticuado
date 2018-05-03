module Anticuado
  module Ruby
    class Bundler < Anticuado::Base
      attr_reader :project_dir
      attr_reader :outdated_libraries

      def initialize(project_dir = nil)
        @project_dir = project_dir
        @outdated_libraries = ''
      end

      def outdated
        return puts "have no bundle command" if `which bundle`.empty?

        if @project_dir
          current_dir = Anticuado.current_dir
          Dir.chdir Anticuado.project_dir(@project_dir)
          @outdated_libraries = run_outdated
          Dir.chdir current_dir
        else
          @outdated_libraries = run_outdated
        end
        @outdated_libraries
      end

      # @param [String] outdated The result of command `bundle outdated`. If it's no argument, the method use the result of `outdated`.
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(outdated = nil)
        outdated = @outdated_libraries if outdated.nil?

        array = outdated.split(/\R/).map(&:strip)
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

      private

      def run_outdated
        `bundle install`
        `bundle outdated`
      end
    end # class Bundler
  end # module Ruby
end # module Anticuado
