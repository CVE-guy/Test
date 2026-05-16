require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('valid@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid-email').for(:email) }
    it { is_expected.not_to allow_value('userexample.com').for(:email) }
    it { is_expected.not_to allow_value('').for(:email) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_most(20) }
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_length_of(:password).is_at_least(8).allow_nil }
  end

  describe '#authenticate' do
    let(:user) { create(:user, password: 'password123') }

    it 'returns the user when the password is correct' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'returns false when the password is incorrect' do
      expect(user.authenticate('wrongpassword')).to be(false)
    end

    it 'stores password as a digest' do
      expect(user.password_digest).to be_present
    end

    it 'does not store the plain-text password' do
      expect(user.password_digest).not_to eq('password123')
    end
  end

  context 'when password is nil on an existing record' do
    it 'remains valid' do
      user = create(:user)
      user.password = nil
      user.password_confirmation = nil
      expect(user).to be_valid
    end
  end
end
