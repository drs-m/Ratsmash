class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :subject
      t.string :author
      t.text :content

      t.timestamps
    end
  end
end
