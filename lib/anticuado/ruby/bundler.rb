module Anticuado
  module Ruby
    class Bundler < Anticuado::Base
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
        @outdated_libraries = outdated unless outdated.nil?

        array = @outdated_libraries.split(/\R/).map(&:strip)
        index = array.find_index("Outdated gems included in the bundle:")

        return [] if index.nil?

        @formatted_outdated_libraries = array[index + 1..array.size].map { |library|
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

      def update(target_name = nil)
        if @project_dir
          Dir.chdir(@project_dir) do
            do_update target_name
          end
        else
          do_update target_name
        end
      end

      private

      def do_update(target = nil)
        if target.nil?
          `bundle update`
        end

        raise ArgumentError, "An argument should be Array like ['cocoapod']" unless target.is_a? Array

        target.each { |library_name| `bundle update #{library_name}`}
      end

      def run_outdated
        `bundle install`
        `bundle outdated`
      end
    end # class Bundler
  end # module Ruby
end # module Anticuado
