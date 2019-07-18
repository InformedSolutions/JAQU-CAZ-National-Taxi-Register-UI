# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailForm, type: :model do
  subject(:form) { described_class.new(email) }

  let(:email) { 'user@example.com' }

  it 'is valid with a proper email' do
    expect(form.valid?).to eq(true)
  end

  it 'has email set as parameter' do
    expect(form.parameter).to eq(email)
  end

  context 'when email is empty' do
    let(:email) { '' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must enter your email address')
    end
  end

  context 'when email is in invalid format' do
    let(:email) { 'user' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must enter your email in valid format')
    end
  end
end
