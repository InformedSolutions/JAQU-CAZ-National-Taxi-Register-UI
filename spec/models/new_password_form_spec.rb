# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewPasswordForm, type: :model do
  subject(:form) do
    described_class.new(
      password: password, confirmation: confirmation, old_password_hash: old_password_hash
    )
  end

  let(:password) { 'password' }
  let(:confirmation) { password }
  let(:old_password_hash) { Digest::MD5.hexdigest('old_password') }

  it 'is valid with a proper password' do
    expect(form).to be_valid
  end

  context 'when password is empty' do
    let(:password) { '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(I18n.t('password.errors.password_required'))
    end
  end

  context 'when password confirmation is empty' do
    let(:confirmation) { '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(I18n.t('password.errors.password_required'))
    end
  end

  context 'when password confirmation is different' do
    let(:confirmation) { 'other_password' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(I18n.t('password.errors.password_equality'))
    end
  end

  context 'when password is same as old_password' do
    let(:old_password_hash) { Digest::MD5.hexdigest(password) }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq(I18n.t('password.errors.password_unchanged'))
    end
  end
end
