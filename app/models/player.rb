class Player < ApplicationRecord
  belongs_to :board
  has_many :picks

  validates :board_id, presence: true
  validates :name, presence: true
end
