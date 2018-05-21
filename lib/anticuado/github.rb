require 'git'
require 'octokit'

module Anticuado
  class GitHub
    attr_reader :repo_uri, :repo_name, :git, :client

    def initialize(repository_name, enterprise: true, api_endpoint: nil)
      @repo_name = repository_name

      @client = if enterprise
                  ::Octokit::Client.new(
                      access_token: ENV['GHE_ACCESS_TOKEN'] || 'dummy_token',
                      api_endpoint: api_endpoint || ENV['GHE_API_ENDPOINT'], # 'https://example.api.endpoint/api/v3/'
                      )
                else
                  ::Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
                end
      @repo_uri = "git@#{URI.parse(enterprise ? @client.api_endpoint : @client.web_endpoint).host}:#{@repo_name}.git"
    end

    def clone_or_open_to(target_path)
      @git = begin
        ::Git.clone(@repo_uri, target_path)
      rescue
        g = ::Git.open(target_path)
        g.pull
        g
      end
    end

    def create_a_new_pull_request(base_branch:, head_branch: (Time.now.strftime '%Y%m%d-%H%M%S'), update_libraries: nil)
      remote_name = 'origin'

      begin
        create_a_branch_local head_branch
        commit_all_changes

        git_push_to_remote remote_name, head_branch
        create_pull_request(base_branch: base_branch, head_branch: head_branch, title: github_pr_title(head_branch), body: github_pr_body(update_libraries))

        delete_a_branch_local head_branch
      rescue Git::GitExecuteError => e
        puts "no changes: #{e}, #{e.message}"
      end
    end

    private

    def github_pr_title(message)
      "update #{message}"
    end

    def github_pr_body(update_libraries)
      return 'update libraries' if update_libraries.nil?
      update_libraries.reduce("# Update libraries\n") do |acc, library|
        acc << "- #{library}\n"
      end
    end

    def commit_all_changes_message
      "update libraries"
    end

    def commit_all_changes
      @git.commit_all(commit_all_changes_message)
    end

    def create_a_branch_local(branch_name)
      @git.branch(branch_name).checkout
    end

    def delete_a_branch_local(branch_name)
      @git.checkout # We should change current branch first
      @git.branch(branch_name).delete
    end

    def git_push_to_remote(remote_name, head_branch)
      @git.push(remote_name, head_branch)
    end

    def create_pull_request(base_branch:, head_branch:, title:, body:)
      @client.create_pull_request @repo_name, base_branch, head_branch, title, body
    end
  end
end # module Anticuado
