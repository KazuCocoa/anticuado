module Anticuado
  module Android
    class Gradle
      def initialize
        @outdated = ""
      end

      # require: https://github.com/ben-manes/gradle-versions-plugin
      def outdated(revision: "release", format: "plain", outdir: "build/dependencyUpdates")
        `./gradlew dependencyUpdates -Drevision=#{revision} -DoutputFormatter=#{format} -DoutputDir=#{outdir}`
      end

      # @param [File] outdated json_file
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(json_file)
      end
    end # module Gradle
  end # module Android
end # module Anticuado
