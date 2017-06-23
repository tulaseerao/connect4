class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.integer :rows,     default: 6
      t.integer :columns,  default: 7
      t.string :winner
      t.integer :players_count,  default: 2
      t.timestamps
    end
  end
end
