require 'rails_helper'

RSpec.describe Board, type: :model do
 it { should have_many(:players) }
end
