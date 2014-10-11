class CreatePollAnswers < ActiveRecord::Migration
  def change
    create_table :poll_answers do |t|
      t.string :description
      t.integer :poll_id

      t.timestamps
    end
  end
end
