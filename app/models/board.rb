class Board < ApplicationRecord
  has_many :players
  has_many :picks

  after_create :add_players

  private
    def add_players
      DEFAULT_PLAYER_NAMES.each do |name|
        players.create(name: name)
      end
    end

end
