class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :sender
      t.text :text
      t.boolean :teacher

      t.timestamps
    end
  end
end
