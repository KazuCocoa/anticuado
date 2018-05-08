require 'git'
require 'octokit'

module Anticuado
  class GitHub
    attr_reader :repo, :git, :client

    def initialize(repository, enterprise: true)
      @repo = repository
      @client = if enterprise
                  ::Octokit::Client.new(
                      access_token: ENV['GHE_ACCESS_TOKEN'] || 'dummy_token',
                      api_endpoint: 'https://ghe.ckpd.co/api/v3',
                      )
                else
                  ::Octokit::Client.new(:access_token => '2b139ba6302b58c26a2e69d07027137f174a45fd')
                end
    end

    def clone_or_open_to(target_path)
      @git = begin
        ::Git.clone(@repo, target_path)
      rescue
        g = ::Git.open(target_path)
        g.pull
        g
      end
    end

    def create_a_new_pull_request(base_branch:, head_branch: (Time.now.strftime '%Y%m%d-%H%M%S'))
      remote_name = 'origin'
      if !@git.status.changed.empty?
        create_a_branch_local head_branch
        commit_all_changes

        git_push_to_remote remote_name, head_branch
        create_pull_request(base_branch: base_branch, head_branch: head_branch, title: "update #{head_branch}", body: "update")

        delete_a_branch_local head_branch
      else
        puts "no changes"
      end
    end

    private

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
      @git.branch(branch_name).delete
    end

    def git_push_to_remote(remote_name, head_branch)
      @git.push(remote_name, head_branch)
    end

    def create_pull_request(base_branch:, head_branch:, title:, body:)
      @client.create_pull_request @repo, base_branch, head_branch, title, body
    end
  end
end # module Anticuado