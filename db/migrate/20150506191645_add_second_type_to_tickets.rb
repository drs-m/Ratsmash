class AddSecondTypeToTickets < ActiveRecord::Migration
  def change
      change_table :tickets do |t|
         t.rename :amount, :type_1
         t.integer :type_2 
      end
  end
end
