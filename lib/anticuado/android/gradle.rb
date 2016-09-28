module Anticuado
  module Android
    module Gradle
      # require: https://github.com/ben-manes/gradle-versions-plugin
      def self.outdated(revision: "release", format: "plain", outdir: "build/dependencyUpdates")
        `./gradlew dependencyUpdates -Drevision=#{revision} -DoutputFormatter=#{format} -DoutputDir=#{outdir}`
      end
    end # module Gradle
  end # module Android
end # module Anticuado
