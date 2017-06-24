class CreatePicks < ActiveRecord::Migration[5.0]
  def change
    create_table :picks do |t|
      t.references :board
      t.references :player
      t.integer :row
      t.integer :column
      t.timestamps
    end
  end
end
