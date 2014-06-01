class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.boolean :gender
      t.string :mail_address
      t.string :password_digest
      t.string :auth_token
      t.boolean :admin_permissions
      t.boolean :closed
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end
  end
end
