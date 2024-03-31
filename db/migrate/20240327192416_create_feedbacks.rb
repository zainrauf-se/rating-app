class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :comment
      t.integer :owner_id
      t.timestamps
    end

    add_index :feedbacks, :user_id
    add_index :feedbacks, :post_id
    add_index :feedbacks, :owner_id
  end
end
