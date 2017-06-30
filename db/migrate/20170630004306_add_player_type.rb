class AddPlayerType < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :player_type, :string, default: HUMAN_V_HUMAN
  end
end
