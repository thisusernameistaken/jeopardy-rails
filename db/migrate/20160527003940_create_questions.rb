class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :answer
      t.string :question
      t.string :category
      t.integer :value
      t.integer :game_id

      t.timestamps
    end
  end
end
