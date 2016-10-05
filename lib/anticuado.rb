require "anticuado/version"

require "anticuado/ios/carthage"
require "anticuado/ios/cocoapods"

require "anticuado/java/gradle"

require "anticuado/elixir/hex"

require "anticuado/ruby/bundler"

require "anticuado/javascript/npm"

module Anticuado
  def self.current_dir
    File.expand_path "."
  end

  def self.project_dir(project:)
    File.expand_path(project, ".")
  end
end
