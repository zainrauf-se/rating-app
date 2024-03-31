class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.integer :value, null: false
      t.integer :post_id, null: false
      t.timestamps
    end

    add_index :ratings, :post_id
  end
end
