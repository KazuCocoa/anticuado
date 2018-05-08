module Anticuado
  module IOS
    class CocoaPods < Anticuado::Base
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

      def update_lock(target_name = nil)
        if @project_dir
          Dir.chdir(@project_dir) do
            do_update target_name
          end
        else
          do_update target_name
        end
      end

      # @param [Array] target_names: Name of library.
      def update_lock(target_names = nil)
        return puts "have no pod command" if `which pod`.empty?
        do_update_lock target_names
      end

      # TODO: Should fix. (Not used)
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

      def do_update_lock(target_names = nil)
        if target_names.nil?
          `pod update --project-directory=#{@project_dir}`
        end

        raise ArgumentError, "An argument should be Array like ['PromisesObjC']" unless target_names.is_a? Array
        `pod update #{target_names.join(' ')} --project-directory=#{@project_dir}`
      end

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
