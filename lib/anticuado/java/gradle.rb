require "json"

module Anticuado
  module Java
    class Gradle
      # require: https://github.com/ben-manes/gradle-versions-plugin
      def self.outdated(revision: "release", format: "json", outdir: "build/dependencyUpdates")
        `./gradlew dependencyUpdates -Drevision=#{revision} -DoutputFormatter=#{format} -DoutputDir=#{outdir}`
      end

      def self.parse_json(file)
        str = File.read(file)
        JSON.parse(str)
      end

      # @param [String] outdated The result of command `pod outdated`
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
