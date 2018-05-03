module Anticuado
  class Base
    def outdated(_project)
      raise NotImplementedError
    end

    def format(_outdated)
      raise NotImplementedError
    end

    def self.outdated(_project)
      raise NotImplementedError
    end

    def self.format(_outdated)
      raise NotImplementedError
    end

    private

    def self.update_with_prefix(pod_file_in:, pod_file_out: nil, libraries:, prefix:)
      pod_file_out = pod_file_in if pod_file_out.nil?
      current_pod = File.read(pod_file_in)

      result = current_pod.each_line.reduce("") do |memo, line|
        memo << if line.strip.start_with?(prefix)
                  key = get_key libraries, line
                  key.nil? ? line : line.sub(/[0-9|.]+/, libraries[key])
                else
                  line
                end
      end

      File.write(pod_file_out, result)
      result
    end

    def self.get_key(libraries, line)
      libraries.each_key { |k| return k if line.include?(k.to_s) }
      nil
    end
  end
end
