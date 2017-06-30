class Board < ApplicationRecord
  has_many :players
  has_many :picks

  after_create :add_players

  def pick_player
    (picks.count % 2).zero? ? players.first : players.last
  end

  def player_name
    pick_player.try(:name).try(:capitalize)
  end

  def pick_column
    Pick.random_columns(self)
  end

  def ai_player?
    player_type == HUMAN_V_AI
  end

  private
    def add_players
      DEFAULT_PLAYER_NAMES.each do |name|
        players.create(name: name)
      end
    end

end
