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

      def update_lock(target_names = nil)
        if @project_dir
          Dir.chdir(@project_dir) do
            puts Dir.pwd
            do_update_lock target_names
          end
        else
          do_update_lock target_names
        end
      end

      private

      def do_update_lock(target_names = nil)
        if target_names.nil?
          `bundle update`
        else
          raise ArgumentError, "An argument should be Array like ['cocoapod']" unless target_names.is_a? Array
          `bundle update #{target_names.join(' ')}`          
        end
      end

      def run_outdated
        `bundle install`
        `bundle outdated`
      end
    end # class Bundler
  end # module Ruby
end # module Anticuado
