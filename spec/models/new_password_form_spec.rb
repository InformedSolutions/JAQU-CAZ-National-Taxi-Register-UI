# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewPasswordForm, type: :model do
  subject(:form) { described_class.new(params) }

  let(:params) do
    {
      password: 'password',
      password_confirmation: 'password'
    }
  end

  it 'is valid with a proper password' do
    expect(form).to be_valid
  end

  it 'has params set as parameter' do
    expect(form.parameter).to eq(params)
  end

  context 'when password is empty' do
    before { params[:password] = '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(described_class::REQUIRED_MSG)
    end
  end

  context 'when password confirmation is empty' do
    before { params[:password_confirmation] = '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(described_class::REQUIRED_MSG)
    end
  end

  context 'when password confirmation is different' do
    before { params[:password_confirmation] = '1234' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(described_class::EQUALITY_MSG)
    end
  end
end
