class CreateChildPics < ActiveRecord::Migration
  def change
    create_table :child_pics do |t|
      t.integer :sender_id
      t.string :image

      t.timestamps
    end
  end
end
