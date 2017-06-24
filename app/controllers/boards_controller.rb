class BoardsController < ApplicationController
  before_action :create_board, only: [:create]
  
  def create
    render 'grid'
  end

  private 
    def create_board
      @board = Board.create(rows: 6, columns: 7, players_count: 2)
    end
end
