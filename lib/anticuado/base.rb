module Anticuado
  class Base
    def self.outdated(_project)
      raise NotImplementedError
    end

    def self.format(_outdated)
      raise NotImplementedError
    end
  end
end
