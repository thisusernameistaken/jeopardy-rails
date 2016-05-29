class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :gamecode
      t.string :gamefile
      t.boolean :is_active
      t.integer :num_players

      t.timestamps
    end
  end
end
