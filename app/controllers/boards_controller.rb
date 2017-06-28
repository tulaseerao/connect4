class BoardsController < ApplicationController
  before_action :set_board
  before_action :set_picks
  
  def create
    redirect_to grid_board_path(@board)
  end

  private 
    def set_board
      @board ||= Board.find_or_create_by(id: params[:id])
    end

    def set_picks
      @picks ||= @board.try(:picks)
    end
    
end
