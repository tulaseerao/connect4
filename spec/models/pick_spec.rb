require 'rails_helper'

RSpec.describe Pick, type: :model do
  it { should belong_to :board }
  it { should belong_to :player }

end
