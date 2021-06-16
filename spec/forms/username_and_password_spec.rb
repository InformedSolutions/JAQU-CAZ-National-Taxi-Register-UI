# frozen_string_literal: true

require 'rails_helper'

describe UsernameAndPassword do
  subject { described_class.new(username, password) }

  let(:username) { 'user@example.com' }
  let(:password) { 'password' }

  before { subject.valid? }

  it 'is valid with a proper params' do
    expect(subject).to be_valid
  end

  context 'when `username` and `password` are empty' do
    let(:username) { '' }
    let(:password) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      expect(subject.errors).to eq({ email: 'Enter your email address',
                                     password: 'Enter your password' })
    end
  end

  context 'when `username` is empty' do
    let(:username) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      expect(subject.errors).to eq({ email: 'Enter a valid email address and password',
                                     password: 'Enter a valid email address and password' })
    end
  end

  context 'when `password` is empty' do
    let(:password) { '' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      expect(subject.errors).to eq({ email: 'Enter a valid email address and password',
                                     password: 'Enter a valid email address and password' })
    end
  end

  context 'when `username` is an invalid format' do
    let(:username) { 'invalid_email_format' }

    it 'is not valid' do
      expect(subject).not_to be_valid
    end

    it 'has a proper error message' do
      expect(subject.errors).to eq({ email: 'Enter your email address in a valid format',
                                     password: 'Enter your password' })
    end
  end
end
