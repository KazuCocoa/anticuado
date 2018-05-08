require 'test_helper'

module Anticuado
  class GitTest < Minitest::Test
    def test_with_bundle
      project_name = "project/anticuado-example"
      # https://github.com/KazuCocoa/anticuado-example
      g = ::Anticuado::GitHub.new "KazuCocoa/anticuado-example", enterprise: false
      g.clone_or_open_to project_name

      update_libraries_list = ['anticuado', 'cocoapods']
      bundler = ::Anticuado::Ruby::Bundler.new project_name
      bundler.update_lock update_libraries_list

      Dir.chdir(project_name) do
        g.create_a_new_pull_request base_branch: 'master', head_branch: "update-#{Time.now.strftime '%Y%m%d-%H%M%S'}", update_libraries: update_libraries_list
      end
    end
  end
end


