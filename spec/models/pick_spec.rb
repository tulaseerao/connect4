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
   let(:board_id) { board.id }
   let(:played_id) { board.players.first.id }

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

  describe 'ai player' do
    let!(:board) { Board.create(rows: 6, player_type: HUMAN_V_AI) }
    let(:board_id) { board.id }
    let(:players) { board.players}
    let(:first_player) { players.first }
    let(:last_player) { players.last }
    let(:row_pick) {
      1.upto(3) do |counter|
        row = Pick.assign_row({board_id: board.id, column: 6})
        Pick.create(board_id: board_id, player_id: first_player.id, column: 6, row: row)
      end
    }

    let(:column_pick) {
      1.upto(3) do |counter|
        row = Pick.assign_row({board_id: board.id, column: counter})
        Pick.create(board_id: board_id, player_id: first_player.id, column: counter, row: row)
      end
    }

    it 'ai player should pick column to stop human player winning ' do
      row_pick
      board.reload
      expect(board.winner).to eq(nil)
      expect(board.pick_column).to eq(6)
    end

    it 'ai player should pick row to stop human player winning' do
      column_pick
      board.reload
      expect(board.winner).to eq(nil)
      expect(board.pick_column).to eq(0)
    end
  end

  describe '.winner?' do
     let!(:board) { Board.create(rows: 6) }
     let(:board_id) { board.id }
     let(:first_player) { board.players.first }
     let(:player_id) { first_player.id }
     let(:row_pick) {
        1.upto(4) do |counter|
          row = Pick.assign_row({board_id: board.id, column: 6})
          Pick.create(board_id: board_id, player_id: player_id, column: 6, row: row)
        end
      }
      let(:column_pick) {
        1.upto(4) do |counter|
          row = Pick.assign_row({board_id: board.id, column: counter})
          Pick.create(board_id: board_id, player_id: player_id, column: counter, row: row)
        end
      }

      let(:diagonal_left_pick) {
        1.upto(4) do |counter|
          row = Pick.assign_row({board_id: board.id, column: 4 - counter })
          Pick.create(board_id: board_id, player_id: player_id, column: 4 - counter , row: row)
        end
      }

      let(:diagonal_right_pick) {
        4.downto(1) do |counter|
          row = Pick.assign_row({board_id: board.id, column: 4 - counter })
          Pick.create(board_id: board_id, player_id: player_id, column: 4 - counter , row: row)
        end
      }
   
      it 'have a row winner' do
        row_pick
        board.reload
        expect(board.winner).to eq(first_player.name)
      end

      it 'have a column winner' do 
        column_pick
        board.reload
        expect(board.winner).to eq(first_player.name)
      end

      it 'have a diagonal left winner' do 
        diagonal_left_pick
        board.reload
        expect(board.winner).to eq(first_player.name)
      end

      it 'have a diagonal right winner' do 
        diagonal_right_pick
        board.reload
        expect(board.winner).to eq(first_player.name)
      end
   
  end

end
