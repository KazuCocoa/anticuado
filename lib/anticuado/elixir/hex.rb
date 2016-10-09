module Anticuado
  module Elixir
    module Hex
      # @param [String] project Path to project directory.
      # @return [String] The result of command `mix hex.outdated`.
      def self.outdated(project = nil)
        return puts "have no mix command" if `which mix`.empty?
        `mix local.hex --force`

        if project
          current_dir = Anticuado.current_dir
          Dir.chdir Anticuado.project_dir(project)
          outdated_str = `mix hex.outdated`
          Dir.chdir current_dir
        else
          outdated_str = `mix hex.outdated`
        end

        outdated_str
      end

      # @param [String] outdated The result of command `mix hex.outdated`
      # @return [Array] Array include outdated data.
      #                 If target project have no outdated data, then return blank array such as `[]`
      def self.format(outdated)
        array = outdated.split(/\R/).map(&:strip)
        index = array.find_index("Dependency           Current  Latest  Requirement")
        index = array.find_index { |line| line.scan(/\ADependency\s+Current\s+Latest\s+Requirement\z/) != [] }

        return [] if index.nil?

        array[index + 1..array.size].reduce([]) do |acc, library|
          break acc if library.empty?

          array_lib = library.split(/\s+/)
          current_version = array_lib[1]
          last_version = array_lib[2]

          if current_version != last_version
            acc.push({
                library_name: array_lib[0],
                current_version: current_version,
                available_version: last_version,
                latest_version: last_version
            })
          end

          acc
        end
      end
    end # module Hex
  end # module Elixir
end # module Anticuado
