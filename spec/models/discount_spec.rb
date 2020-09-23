require 'rails_helper'

RSpec.describe Discount do
  it { should validate_presence_of :name}
  it { should validate_presence_of :percent_off}
  it { should validate_presence_of :minimum_items}

  it { should validate_numericality_of :percent_off}
  it { should validate_numericality_of :minimum_items}

  it { should belong_to :merchant}
end
