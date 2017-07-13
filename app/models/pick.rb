class Pick < ApplicationRecord
  include Winner
  include AiPlayer

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

  private

  def reset_row?
    if (column_full?) || out_of_bounds?
      self.column = self.easy_pick(self.board)
      self.row = self.assign_row({board_id: self.board.id, column: self.column})
    end
  end

  def set_winner?
    if winner?
      board.update_attribute(:winner, player.name)
    end
  end
end
