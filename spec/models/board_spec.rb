require 'rails_helper'

RSpec.describe Board, type: :model do
 it { should have_many(:players) }
 it { should have_many(:picks) }

  it 'add default two players after create' do
    board = Board.create(rows: 6)
    expect(Player.count).to eq 2
    expect(Player.first.name).to eq BLUE
    expect(Player.last.name).to eq PINK
  end

end
