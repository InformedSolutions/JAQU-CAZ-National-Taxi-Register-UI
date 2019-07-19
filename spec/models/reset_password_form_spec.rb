# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResetPasswordForm, type: :model do
  subject(:form) { described_class.new(username) }

  let(:username) { 'wojtek' }

  it 'is valid with a proper email' do
    expect(form).to be_valid
  end

  it 'has username set as parameter' do
    expect(form.parameter).to eq(username)
  end

  context 'when username is empty' do
    let(:username) { '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(described_class::REQUIRED_MSG)
    end
  end
end
