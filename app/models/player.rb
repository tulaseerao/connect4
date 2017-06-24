class Player < ApplicationRecord
  belongs_to :board
  has_many :picks
end
