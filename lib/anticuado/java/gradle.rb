require "json"

module Anticuado
  module Java
    class Gradle
      # require: https://github.com/ben-manes/gradle-versions-plugin
      # @param [String] revision "release", "milestone" or "integration". Default is "release".
      # @param [String] format "plain", "json" or "xml". Default is "json".
      # @param [String] outdir Path to output the result. Default is "build/dependencyUpdates".
      def self.outdated(revision: "release", format: "json", outdir: "build/dependencyUpdates")
        `./gradlew dependencyUpdates -Drevision=#{revision} -DoutputFormatter=#{format} -DoutputDir=#{outdir}`
        puts "output file is #{outdir}"
      end

      # @param [String] file_path The result of command `gradle dependencyUpdates` with json format
      # @return [JSON] JSON data
      def self.parse_json(file_path)
        str = File.read(file_path)
        JSON.parse(str)
      end

      # @param [String] outdated_parsed_json The result of command `gradle dependencyUpdates` and json parsed data
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def self.format(outdated_parsed_json)
        outdted = outdated_parsed_json["outdated"]
        return [] if outdted.nil?
        return [] if outdted["dependencies"].nil?

        outdted["dependencies"].map { |library|
          {
              library_name: library["name"],
              current_version: library["version"],
              available_version: library["available"]["release"],
              latest_version: library["available"]["release"]
          }
        }
      end
    end # module Gradle
  end # module Android
end # module Anticuado
