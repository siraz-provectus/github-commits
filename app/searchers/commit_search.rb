class CommitSearch < Searchlight::Search
  def base_query
    Commit.all
  end

  def search_email
    query.of_email(email)
  end

  def search_page
    query.page(page)
  end

  def search_per
    query.per(per)
  end
end
