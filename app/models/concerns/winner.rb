module Winner
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods  
  end

  def current_picks
    @current_picks ||= board.picks.where(player_id: player_id).order(:row, :column)
  end

  def winner?
    current_picks.each do |pick|  
      if matching_pick?(pick, ROW) || matching_pick?(pick, COLUMN) ||
        matching_pick?(pick, D_RIGHT) || matching_pick?(pick, D_LEFT)
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
    options = process_options(options)
    current_picks.where(row: options[:row], column: options[:column]).count > 0
  end

  def process_options(options = {})
    type = options[:type]
    counter = options[:counters]

    options[:row] = (options[:row] + counter) if [ROW, D_LEFT, D_RIGHT].include?(type)
    options[:column] = (options[:column] + counter) if [COLUMN, D_RIGHT].include?(type)
    options[:column] = (options[:column] - counter)  if type == D_LEFT
    options
  end

end
