class UploadCommitsInteractor
  attr_reader :commits, :user

  def initialize(user, commits)
    @user    = user
    @commits = commits
    @connection = ActiveRecord::Base.connection
  end

  def run
    ActiveRecord::Base.transaction do
      clear_db
      @created_user = create_user

      mass_commits_insert(@created_user)
    end

    @created_user
  end

  def clear_db
    User.delete_all
    Commit.delete_all
  end

  def create_user
    users = commits.map{ |x| { name: x[:commit][:committer][:name], email: x[:commit][:committer][:email]} }.uniq
    users = users.map{|x| "('#{x[:name]}', '#{x[:email]}', '#{Time.current.strftime('%Y-%m-%d %H:%M:%S')}', '#{Time.current.strftime('%Y-%m-%d %H:%M:%S')}')"}

    sql = "INSERT INTO users (name, email, created_at, updated_at) VALUES #{users.join(", ")}"
    @connection.execute sql
  end

  def mass_commits_insert(created_user)
    commits_for_save = commits.map{ |x| "('#{User.find_by(name: x[:commit][:committer][:name], email: x[:commit][:committer][:email]).id}',
                                         '#{x[:commit][:tree][:sha]}',
                                         '#{x[:commit][:committer][:date]}',
                                         '#{x[:commit][:message]}',
                                         '#{Time.current.strftime('%Y-%m-%d %H:%M:%S')}',
                                         '#{Time.current.strftime('%Y-%m-%d %H:%M:%S')}')" }

    sql = "INSERT INTO commits (user_id, hash_commit, create_date, description, created_at, updated_at) VALUES #{commits_for_save.join(", ")}"
    @connection.execute sql
  end

  #  Медленнее чем mass_commits_insert
  # def activerecord_extensions_mass_insert(created_user)
  #     values = commits.map{ |x| { user_id: created_user.id,
  #                                hash: x[:commit][:tree][:sha],
  #                                create_date: x[:commit][:committer][:date],
  #                                description: x[:commit][:message] } }
  #     1000.times do
  #         values.push({name: 'Airo', email: 'siraz22@yandex.ru'})
  #     end

  #     Commit.create! values
  # end
end
