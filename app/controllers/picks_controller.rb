class PicksController < ApplicationController
  skip_before_action :verify_authenticity_token,  :only => [:create]
  before_action :set_board
  
  def create
    add_pick_to_board
    redirect_to grid_board_path(@board)
  end

  private

    def set_board
      @board = Board.find_by(id: params[:board_id])
    end

    def add_pick_to_board
      Pick.create(
        board: @board,
        player_id: params[:player_id],
        column: pick_params[:column],
        row: assign_row
      )
    end

    def pick_params
      params.require(:pick).permit(
        :column,
        :row
      )
    end

    def assign_row
      options = {
        board_id: params[:board_id], 
        column: pick_params[:column],
      }
      Pick.assign_row(options)
    end


end
