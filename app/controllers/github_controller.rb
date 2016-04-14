class GithubController < ApplicationController
  before_action :check_params, only: :upload_commits

  expose(:user) { Octokit.user github_params[:username] }

  expose(:commits) {
    repo = Octokit.repo "#{github_params[:username]}/#{github_params[:repo]}"
    repo.rels[:commits].get.data
  }

  def upload_commits
    self.user = UploadCommitsInteractor.new(user, commits).run
    redirect_to commits_url
  end

  private

  def github_params
    params.permit(:username, :repo)
  end

  def check_params
    begin
      user
    rescue => error
      return redirect_to root_url, alert: 'GitHub account not found'
    end

    begin
      commits
    rescue => error
      return redirect_to root_url, alert: 'GitHub repository not found'
    end
  end
end
