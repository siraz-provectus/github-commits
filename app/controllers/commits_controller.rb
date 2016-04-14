class CommitsController < ApplicationController
  expose(:search) {
    search_keys = params.select { |key, value| ['email'].include?(key) }
    search_keys[:page] = params[:page] || 1
    search_keys[:per] = params[:per] || 10

    CommitSearch.new(search_keys)
  }

  expose (:commits) { search.results.includes(:user) }

  def index
  end
end
