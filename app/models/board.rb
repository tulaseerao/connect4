class Board < ApplicationRecord
  has_many :players
  has_many :picks
end
