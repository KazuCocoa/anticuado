module Anticuado
  module IOS
    module CocoaPods
      def self.outdated
        `pod outdated`
      end
    end # module CocoaPods
  end # module IOS
end # module Anticuado
