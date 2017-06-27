require 'rails_helper'

RSpec.describe Board, type: :model do
  it { should have_many(:players) }
  it { should have_many(:picks) }

  let!(:board) { Board.create(rows: 6) }
  let(:board_id) { board.id}
  let(:players) { board.players}
  let(:first_player) { players.first }
  let(:last_player) { players.last }
  let(:row) { Pick.assign_row({board_id: board.id, column: 6}) }
  
  describe 'pick_player' do
    it 'add default two players after create' do
      expect(Player.count).to eq 2
      expect(Player.first.name).to eq BLUE
      expect(Player.last.name).to eq PINK
    end

    context 'when there are no picks available' do
      it 'pick a first player' do
        expect(board.pick_player).to eq first_player
      end
    end

    context 'when there are picks available' do
      let!(:pick) { Pick.create(board_id: board_id, player_id: first_player.id, column: 6, row: row) }
      
      it 'pick a next player' do
        expect(board.pick_player).to eq last_player
      end
    end

    context 'when picks  divisible by 2' do
      let!(:first_pick) { Pick.create(board_id: board_id, player_id: first_player.id, column: 6, row: row) }
      let(:last_row) { Pick.assign_row({board_id: board.id, column: 6}) }
      let!(:second_pick) { Pick.create(board_id: board_id, player_id: last_player.id, column: 6, row: last_row) }
      
      it 'pick a first player' do
        expect(board.pick_player).to eq first_player
      end
    end
  end

end
