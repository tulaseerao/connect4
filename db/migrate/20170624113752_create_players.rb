class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
     create_table :players do |t|
      t.references :board
      t.string :name

      t.timestamps
    end
  end
end
