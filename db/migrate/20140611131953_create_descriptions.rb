class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.integer :from_id
      t.integer :for_id
      t.text :content
      t.integer :status
      t.string :additional_authors

      t.timestamps
    end
  end
end
