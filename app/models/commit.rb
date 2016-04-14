class Commit < ActiveRecord::Base
  belongs_to :user

  validates :description, :hash_commit, :user_id, :author_email, :create_date, presence: true

  scope :of_email, ->(email) {
    joins(:user).
    where('users.email = ?', email)
  }
end
