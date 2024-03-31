class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :user_id, null: false
      t.string :author_ip
      t.string :author_login
      t.timestamps
    end

    add_index :posts, :user_id
  end
end
