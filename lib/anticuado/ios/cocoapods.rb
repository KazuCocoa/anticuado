module Anticuado
  module IOS
    class CocoaPods < Anticuado::Base
      # @param [String] library: Name of library.
      # @return [String] The result of command `pod outdated`.
      def update_lock(library: nil)
        return puts "have no pod command" if `which pod`.empty?
        
        if library
          `pod update #{library}`
        else
          `pod update`
        end
      end

      # @return [String] The result of command `pod outdated`.
      def outdated
        return puts "have no pod command" if `which pod`.empty?

        @outdated_libraries = if @project_dir
                                `pod install --project-directory=#{@project_dir}`
                                `pod outdated --project-directory=#{@project_dir}`
                              else
                                `pod install`
                                `pod outdated`
                              end
      end

      # @param [String] outdated The result of command `pod outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def format(outdated = nil)
        @outdated_libraries = outdated unless outdated.nil?

        array = @outdated_libraries.split(/\R/).map(&:strip)
        index = array.find_index("The following pod updates are available:")

        return [] if index.nil?

        @formatted_outdated_libraries = array[index + 1..array.size].map { |library|
          versions = library.split(/\s/) # e.g. ["-", "AFNetworking", "2.5.4", "->", "3.1.0", "(latest", "version", "3.1.0)"]
          if versions[0] == "-"
            {
                library_name: versions[1],
                current_version: versions[2],
                available_version: versions[4],
                latest_version: versions[7].delete(")")
            }
          end
        }.compact
      end

      # @param [String] pod_file_in The file path to Podfile you'd like to update
      # @param [String] pod_file_out The file path to new Podfile updated. Default is nil and then `pod_file_in` is used
      #                   as the file path
      # @param [Hash] libraries The library name you'd like to update
      #                   {library_name: "version", library_name2: "version"}
      # @return [String] new Podfile
      def update(pod_file_in:, pod_file_out: nil, libraries:)
        update_with_prefix(pod_file_in: pod_file_in, pod_file_out: pod_file_out, libraries: libraries, prefix: "pod ")
      end

      private

      def update_with_prefix(pod_file_in:, pod_file_out: nil, libraries:, prefix:)
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

      def get_key(libraries, line)
        libraries.each_key { |k| return k if line.include?(k.to_s) }
        nil
      end
    end # class CocoaPods
  end # module IOS
end # module Anticuado
