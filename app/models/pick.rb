class Pick < ApplicationRecord
  include Winner

  belongs_to :board
  belongs_to :player

  validates :board_id, presence: true
  validates :player_id, presence: true
  validates :row, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :column, presence: true

  after_create :set_winner?
  before_create :reset_row?

  def self.assign_row(options = {})
    board = Board.find_by(id: options[:board_id])
    picks = board.picks.where(column: options[:column])

    picks.count > 0 ? (picks.order(:row).first.row - 1) : board.rows
  end

  def self.random_columns(board)
    if board.ai_player?
      self.hard_pick(board)
    else
      self.easy_pick(board)
    end
  end

  def self.easy_pick(board)
    columns = 0.upto(board.columns - 1).to_a - board.picks.where(row: 1).map(&:column).flatten
    
    column  = columns.sample 
    columns.each do |col|
      if board.picks.where(column: col).count!= board.rows
        return col
      end
    end
  end

  def self.hard_pick(board)
    play = self.pay_on_row(board)
    if play
      return play
    end
    self.easy_pick(board)
  end

  def self.player_picks(board)
    if board.picks.count < 2
      return false
    end
    board.picks.try(:last).try(:player).try(:picks)
  end

  def self.ai_picks(board)
    if board.picks.count < 2
      return false
    end
    board.picks.where(player_id: board.players.last.id)
  end

  def self.pay_on_row(board)
    picks = self.player_picks(board)
    ai_picks = self.ai_picks(board)
    found_column = (self.pick_right_column(board, ai_picks) || self.pick_right_row(board, ai_picks)) if ai_picks
    found_column = (self.pick_right_column(board, picks) || self.pick_right_row(board, picks)) if picks && !found_column
    return found_column
  end

  private

  def self.pick_right_column(board, picks)
    0.upto(board.columns - 1).each do |column|
      if board.picks.where(column: column).count!= board.rows && picks.where(column: column).count > 2 
        return  column
      end          
    end

    return false
  end

  def self.pick_right_row(board, picks)
    all_columns = 0.upto(board.columns - 1).to_a
    board.rows.downto(1).each do |row|
      row_picks = picks.where(row: row).order(:column)

      if row_picks.count > 2
        empty_columns = all_columns - row_picks.map(&:column)
        empty_columns.each do |rem_col|
          if board.picks.where(column: rem_col, row: row).empty?
            return rem_col
          end
        end   
      end
    end

    return false
  end


  def reset_row?
    if (column_full?) || out_of_bounds?
      self.column = Pick.easy_pick(self.board)
      self.row = Pick.assign_row({board_id: self.board.id, column: self.column})
    end
  end

  def column_full?
     picks = self.board.picks.where(column: self.column)
     picks && picks.count == board.rows
  end

  def out_of_bounds?
    (self.column > (self.board.columns - 1) || self.column < 0)
  end

  def set_winner?
    if winner?
      board.update_attribute(:winner, player.name)
    end
  end
end
