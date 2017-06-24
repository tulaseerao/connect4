require 'rails_helper'

RSpec.describe Player, type: :model do
 it { should belong_to :board }
 it { should have_many(:picks) }
end
