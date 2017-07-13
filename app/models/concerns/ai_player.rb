module AiPlayer
  extend ActiveSupport::Concern

  included do
  end

  def column_full?
     picks = self.board.picks.where(column: self.column)
     picks && picks.count == board.rows
  end

  def out_of_bounds?
    (self.column > (self.board.columns - 1) || self.column < 0)
  end
  
  module ClassMethods
    
    def random_columns(board)
      board.ai_player? ? hard_pick(board) : easy_pick(board)
    end

    def easy_pick(board)
      columns = 0.upto(board.columns - 1).to_a - board.picks.where(row: 1).map(&:column).flatten
      
      column  = columns.sample 
      columns.each do |col|
        if board.picks.where(column: col).count!= board.rows
          return col
        end
      end
    end

    def hard_pick(board)
      pay_on_row(board) || easy_pick(board)
    end

    def player_picks(board)
      return false if board.picks.count < 2
      board.picks.try(:last).try(:player).try(:picks)
    end

    def ai_picks(board)
      return false if board.picks.count < 2
      board.picks.where(player_id: board.players.last.id)
    end

    def pay_on_row(board)
      picks = player_picks(board)
      ai_picks = ai_picks(board)
      found_column = (pick_right_column(board, ai_picks) || pick_right_row(board, ai_picks)) if ai_picks
      found_column = (pick_right_column(board, picks) || pick_right_row(board, picks)) if picks && !found_column
      return found_column
    end

    def pick_right_column(board, picks)
      0.upto(board.columns - 1).each do |column|
        if board.picks.where(column: column).count!= board.rows && picks.where(column: column).count > 2 
          return  column
        end          
      end

      return false
    end

    def pick_right_row(board, picks)
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
  end
end
