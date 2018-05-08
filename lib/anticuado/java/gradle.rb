require "json"

module Anticuado
  module Java
    class Gradle < Anticuado::Base
      NO_VERSION = "-"

      # require: https://github.com/ben-manes/gradle-versions-plugin
      # @param [String] revision "release", "milestone" or "integration". Default is "release".
      # @param [Bool] wrapper Use gradle wrapper or use gradle directory.
      # @param [String] format "plain", "json" or "xml". Default is "json".
      # @param [String] outdir Path to output the result. Default is "build/dependencyUpdates".
      def outdated(wrapper = false, revision = "release", format = "json", outdir = "build/dependencyUpdates")
        return puts "have no gradle command" if !wrapper && `which gradle`.empty?

        if @project_dir
          Dir.chdir(@project_dir) do
            `#{gradle(wrapper)} dependencyUpdates -Drevision=#{revision} -DoutputFormatter=#{format} -DoutputDir=#{outdir}`
          end
        else
          `#{gradle(wrapper)} dependencyUpdates -Drevision=#{revision} -DoutputFormatter=#{format} -DoutputDir=#{outdir}`
        end

        puts "output file is #{outdir}"
      end

      # @param [String] file_path The result of command `gradle dependencyUpdates` with json format
      # @return [JSON] JSON data
      def parse_json(file_path)
        str = File.read(file_path)
        @outdated_libraries = JSON.parse(str)
      end

      # @param [String] outdated_parsed_json The result of command `gradle dependencyUpdates` and json parsed data
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(outdated_parsed_json = nil, filter = %w(alpha beta rc cr m))
        @outdated_libraries = outdated_parsed_json unless outdated_parsed_json.nil?

        outdted = @outdated_libraries["outdated"]
        return [] if outdted.nil?
        return [] if outdted["dependencies"].nil?

        @formatted_outdated_libraries = outdted["dependencies"].map { |library|
          available_version = filter(filter, library["available"]["release"])
          latest_version = filter(filter, library["available"]["release"])

          unless available_version == NO_VERSION && latest_version == NO_VERSION
            {
                group_name: library["group"],
                library_name: library["name"],
                current_version: library["version"],
                available_version: available_version,
                latest_version: latest_version
            }
          end
        }.compact
      end

      private

      def gradle(wrapper = false)
        return "./gradlew" if wrapper
        "gradle"
      end

      def filter(revisions, string)
        result = revisions.find { |qualifier| string.match(/(?i).*[.-]#{qualifier}[.\d-]*/) }
        return NO_VERSION if result
        string
      end
    end # class Gradle
  end # module Android
end # module Anticuado
