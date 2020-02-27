# frozen_string_literal: true

RSpec.shared_examples 'an invalid attribute input' do |attribute, error_message|
  it { is_expected.not_to be_valid }

  it 'has a proper error message' do
    expect(form.errors.messages[attribute]).to include(error_message)
  end
end
