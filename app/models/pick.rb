class Pick < ApplicationRecord
  belongs_to :board
  belongs_to :player

  validates :board_id, presence: true
  validates :player_id, presence: true
  validates :row, presence: true,:numericality => { :greater_than_or_equal_to => 1 }
  validates :column, presence: true

  after_create :set_winner?

  def self.assign_row(options = {})
    board = Board.find_by(id: options[:board_id])
    picks = board.picks.where(column: options[:column])

    picks.count > 0 ? (picks.order(:row).first.row - 1) : board.rows
  end

  private

  def set_winner?
    if winner?
      board.update_attribute(:winner, player.name)
    end
  end

  def current_picks
    @current_picks ||= board.picks.where(player_id: player_id).order(:row, :column)
  end

  def winner?
    current_picks.each do |pick|  
      if matching_pick?(pick, ROW) || matching_pick?(pick, COLUMN)
        return true
      end
    end

    return false
  end

  def matching_pick?(pick, type)
    found_pick = false
    matched_pick = 0
    1.upto(3) do |counters|
      if check_matched_pick?({type: type, row: pick.row, column: pick.column, counters: counters})
        matched_pick = matched_pick + 1
        if matched_pick == 3
          found_pick = true
          break
        end
      end
    end

    return found_pick
  end

  def check_matched_pick?(options = {})
    row = options[:row]
    column = options[:column]
    type = options[:type]
    counter = options[:counters]
    row = (row + counter) if type == ROW
    column = (column + counter) if type == COLUMN

    current_picks.where(row: row, column: column).count > 0
  end

end
