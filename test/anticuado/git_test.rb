require 'test_helper'

module Anticuado
  class GitTest < Minitest::Test
    # Notice:
    # # Ruby bundler has nested bundler difficulty. In the case, you should implement script to avoid the case.
    #
    # @ example
    #
    #     ```shell
    #     ruby script-which-handle-git.rb
    #
    #     cd go/to/the/target/root
    #     bundle install
    #     bundle update
    #     cd ../../..
    #
    #     ruby create-a-pr-if-the-update-has-diff.rb
    #     ```
    def test_with_bundle
      skip('by default')

      # clone and set default branch
      project_name = "project/anticuado-example" # To avoid nested bundler
      # https://github.com/KazuCocoa/anticuado-example
      g = ::Anticuado::GitHub.new "KazuCocoa/anticuado-example", enterprise: false
      g.clone_or_open_to project_name

      # update
      update_libraries_list = ['anticuado', 'cocoapods']
      bundler = ::Anticuado::Ruby::Bundler.new project_name
      bundler.update_lock update_libraries_list

      # create a PR
      Dir.chdir(project_name) do
        g.create_a_new_pull_request base_branch: 'master', head_branch: "update-#{Time.now.strftime '%Y%m%d-%H%M%S'}", update_libraries: update_libraries_list
      end
    end
  end
end


