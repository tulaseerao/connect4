require 'rails_helper'

RSpec.describe Pick, type: :model do
  it { should belong_to :board }
  it { should belong_to :player }

  it { should validate_presence_of :board_id }
  it { should validate_presence_of :player_id }
  it { should validate_presence_of :row }
  it { should validate_presence_of :column }
  it { should validate_numericality_of(:row) }
  it { should_not allow_value(0).for(:row) }

  describe '#assign_row' do
   let!(:board) { Board.create(rows: 6) }
   let(:board_id) { board.id}
   let(:played_id) { board.players.first.id}

    it 'assign last row when no rows picked' do
      row = Pick.assign_row({board_id: board.id, column: 6})
      expect(row).to eq board.rows
    end

    it 'assign top of the already assigned row' do
      row = Pick.assign_row({board_id: board.id, column: 6})
      Pick.create(board_id: board_id, player_id: played_id, column: 6, row: row)
      row = Pick.assign_row({board_id: board.id, column: 6})
      expect(row).to eq (board.rows - 1)
    end
  end

end
