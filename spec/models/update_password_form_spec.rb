# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdatePasswordForm, type: :model do
  subject(:form) { described_class.new(params) }

  let(:params) do
    {
      email: 'user@example.com',
      confirmation_code: '1234',
      password: 'password',
      password_confirmation: 'password'
    }.as_json
  end

  it 'is valid with a proper password' do
    expect(form.valid?).to eq(true)
  end

  it 'has params set as parameter' do
    expect(form.parameter).to eq(params)
  end

  context 'when password is empty' do
    before { params['password'] = '' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must enter your password')
    end
  end

  context 'when confirmation code is empty' do
    before { params['confirmation_code'] = '' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must enter your confirmation code')
    end
  end

  context 'when password confirmation is empty' do
    before { params['password_confirmation'] = '' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must confirm your password')
    end
  end

  context 'when password confirmation is different' do
    before { params['password_confirmation'] = '1234' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq("Your password doesn't match password confirmation")
    end
  end
end
