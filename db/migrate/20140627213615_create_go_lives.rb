class CreateGoLives < ActiveRecord::Migration
  def change
    create_table :go_lives do |t|
      t.boolean :send_mails
      t.integer :xpos
      t.integer :ypos

      t.timestamps
    end
  end
end
