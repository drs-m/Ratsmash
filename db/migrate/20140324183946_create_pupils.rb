class CreatePupils < ActiveRecord::Migration
  def change
    create_table :pupils do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :gender
      t.string :mail_address
      t.string :password_digest
      t.string :password_resetkey
      t.boolean :admin_permissions

      t.timestamps
    end
  end
end
