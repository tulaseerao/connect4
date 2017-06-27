module BoardsHelper

  def pick_color_class(board, options={})
    if board.present?
      pick = board.picks.find_by(row: options[:row], column: options[:column])
      pick.try(:player).try(:name)
    end
  end
end
