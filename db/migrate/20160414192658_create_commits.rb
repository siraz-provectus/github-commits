class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.datetime :create_date
      t.integer :user_id
      t.string :hash_commit
      t.string :description

      t.timestamps null: false
    end
    add_index :commits, :user_id
  end
end
