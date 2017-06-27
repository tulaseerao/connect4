require 'rails_helper'

RSpec.describe PicksController, type: :controller do
  
  describe 'POST #create' do
    let!(:board) { Board.create(rows: 6)}
    let(:player) { board.players.first}
    let(:params) do
      {
        pick: {
          column: 0
        },
        board_id: board.id,
        player_id: player.id
      }
    end

    it 'creates a pick' do
      post :create, params: params
      expect(Pick.last.column).to eq(params[:pick][:column])
      expect(Pick.last.row).to eq(board.rows)
    end
  end
end
