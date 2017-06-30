module BoardsHelper

  def pick_color_class(picks, options={})
    return 'empty-cell' if picks.empty?
    if picks.present?
      if pick = picks.find_by(row: options[:row], column: options[:column])
        pick.try(:player).try(:name)
      else
        'empty-cell'
      end
    end
  end

  def toggle_player

  end


  def no_winner?(picks,board)
    if picks.present? && board.present? && board.winner.nil?
      picks.count == (board.rows * board.columns)
    end
  end
end
