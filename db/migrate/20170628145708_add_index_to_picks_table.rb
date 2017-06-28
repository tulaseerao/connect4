class AddIndexToPicksTable < ActiveRecord::Migration[5.0]
  def change
    add_index :picks, ['board_id','row', 'column'], name: 'index_picks_on_board_row_column', unique: false
    add_index :picks, ['row', 'column'], name: 'index_picks_on_row_column', unique: false
    add_index :players, ['board_id'], name: 'index_player_on_board_id', unique: false
  end
end
