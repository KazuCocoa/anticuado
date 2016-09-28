module Anticuado
  module IOS
    module Carthage
      def self.outdated
        `carthage outdated`
      end
    end # module Carthage
  end # module IOS
end # module Anticuado
