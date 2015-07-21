class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :body
      t.integer :stars
      t.string :images, array: true, default: true
      t.string :contact
      t.boolean :anonymous, default: false
      t.integer :product_id, index: true

      t.timestamps
    end
  end
end
