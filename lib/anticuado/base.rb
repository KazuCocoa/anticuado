module Anticuado
  class Base
    attr_reader :project_dir, :outdated_libraries, :formatted_outdated_libraries

    def initialize(project_dir = nil)
      @project_dir = project_dir
      @outdated_libraries = ''
      @formatted_outdated_libraries = []
    end

    def outdated(_project)
      raise NotImplementedError
    end

    def format(_outdated)
      raise NotImplementedError
    end

    def update(target_name = nil)
      raise NotImplementedError
    end
  end
end
