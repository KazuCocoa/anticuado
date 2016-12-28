module Anticuado
  module JavaScript
    class Npm < Anticuado::Base
      # @param [String] project Path to project directory.
      # @return [String] The result of command `npm outdated`.
      def self.outdated(project = nil)
        return puts "have no npm command" if `which npm`.empty?

        if project
          current_dir = Anticuado.current_dir
          Dir.chdir Anticuado.project_dir(project)
          `npm install`
          outdated_str = `npm outdated`
          Dir.chdir current_dir
        else
          outdated_str = `npm outdated`
        end
        outdated_str
      end

      # @param [String] outdated The result of command `npm outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def self.format(outdated)
        array = outdated.split(/\R/).map(&:strip)
        index = array.find_index { |line| line.scan(/\APackage\s+Current\s+Wanted\s+Latest\s+Location\z/) != [] }

        return [] if index.nil?

        array[index + 1...array.size].map do |library|
          versions = library.split(/\s+/) # e.g. ["babel-brunch", "6.0.2", "6.0.6", "6.0.6"]
          {
              library_name: versions[0],
              current_version: versions[1],
              available_version: versions[2],
              latest_version: versions[3]
          }
        end
      end
    end # class Npm
  end # module JavaScript
end # module Anticuado
