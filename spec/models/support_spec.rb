# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Support, type: :model do
  describe 'validation' do
    it 'has a valid factory' do
      expect(build(:support)).to be_valid
    end

    %i[name message email subject].each do |attr|
      it "is not valid without #{attr}" do
        expect(build(:support, attr => nil)).to_not be_valid
      end
    end
  end
end
