# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VrnForm, type: :model do
  subject(:form) { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }

  context 'with proper VRN' do
    it { is_expected.to be_valid }
  end

  context 'VRN validation' do
    before { form.valid? }

    context 'when VRN is empty' do
      let(:vrn) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.vrn_missing')
    end

    context 'when VRN is too long' do
      let(:vrn) { 'ABCDE' * 4 }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.vrn_too_long')
    end

    context 'when VRN has special signs' do
      let(:vrn) { 'ABCDE$%' }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('vrn_form.invalid_format')
    end
  end
end
