class BoardsController < ApplicationController
  before_action :set_board
  
  def create
    redirect_to grid_board_path(@board)
  end

  private 
    def set_board
      @board = Board.find_or_create_by(id: params[:id])
    end
    
end
