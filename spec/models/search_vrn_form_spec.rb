# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchVrnForm, type: :model do
  subject(:form) { described_class.new(params) }

  let(:params) do
    {
      vrn: vrn,
      historic: historic,
      start_date_day: start_date_day,
      start_date_month: start_date_month,
      start_date_year: start_date_year,
      end_date_day: end_date_day,
      end_date_month: end_date_month,
      end_date_year: end_date_year
    }
  end

  let(:vrn) { 'CU57ABC' }
  let(:historic) { 'false' }
  let(:start_date_day) { '10' }
  let(:start_date_month) { '3' }
  let(:start_date_year) { '2020' }
  let(:end_date_day) { '14' }
  let(:end_date_month) { '3' }
  let(:end_date_year) { '2020' }

  before { form.valid? }

  context 'with proper VRN' do
    it { is_expected.to be_valid }
  end

  context 'VRN validation' do
    context 'when VRN is empty' do
      let(:vrn) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('search_vrn_form.vrn_missing')
    end

    context 'when VRN is too long' do
      let(:vrn) { 'ABCDE' * 4 }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('search_vrn_form.vrn_too_long')
    end

    context 'when VRN has special signs' do
      let(:vrn) { 'ABCDE$%' }

      it_behaves_like 'an invalid attribute input', :vrn, I18n.t('search_vrn_form.invalid_format')
    end
  end

  describe 'historical search' do
    let(:historic) { 'true' }

    context 'with proper VRN and dates' do
      it { is_expected.to be_valid }
    end

    context 'with invalid start dates' do
      context 'when day is missing' do
        let(:start_date_day) { '' }

        it_behaves_like 'an invalid attribute input', :start_date, 'Start date must include a day'
      end

      context 'when month is missing' do
        let(:start_date_month) { '' }

        it_behaves_like 'an invalid attribute input',
                        :start_date,
                        'Start date must include a month'
      end

      context 'when year is missing' do
        let(:start_date_year) { '' }

        it_behaves_like 'an invalid attribute input', :start_date, 'Start date must include a year'
      end

      context 'when day and month are missing' do
        let(:start_date_day) { '' }
        let(:start_date_month) { '' }

        it_behaves_like 'an invalid attribute input',
                        :start_date,
                        'Start date must include a day and month'
      end

      context 'when day and year are missing' do
        let(:start_date_day) { '' }
        let(:start_date_year) { '' }

        it_behaves_like 'an invalid attribute input',
                        :start_date,
                        'Start date must include a day and year'
      end

      context 'when month and year are missing' do
        let(:start_date_month) { '' }
        let(:start_date_year) { '' }

        it_behaves_like 'an invalid attribute input',
                        :start_date,
                        'Start date must include a month and year'
      end

      context 'when the start date not in the past' do
        context 'show errors' do
          let(:start_date_day) { Time.zone.tomorrow.day.to_s }
          let(:start_date_month) { Time.zone.tomorrow.month.to_s }
          let(:start_date_year) { Time.zone.tomorrow.year.to_s }
          let(:end_date_day) { Time.zone.now.day.to_s }
          let(:end_date_month) { Time.zone.now.month.to_s }
          let(:end_date_year) { Time.zone.now.year.to_s }

          it_behaves_like 'an invalid attribute input',
                          :start_date,
                          'Start date must be in the past'
        end
      end
    end

    context 'with invalid end dates' do
      context 'when day is missing' do
        let(:end_date_day) { '' }

        it_behaves_like 'an invalid attribute input', :end_date, 'End date must include a day'
      end

      context 'when month is missing' do
        let(:end_date_month) { '' }

        it_behaves_like 'an invalid attribute input', :end_date, 'End date must include a month'
      end

      context 'when year is missing' do
        let(:end_date_year) { '' }

        it_behaves_like 'an invalid attribute input', :end_date, 'End date must include a year'
      end

      context 'when day and month are missing' do
        let(:end_date_day) { '' }
        let(:end_date_month) { '' }

        it_behaves_like 'an invalid attribute input',
                        :end_date,
                        'End date must include a day and month'
      end

      context 'when day and year are missing' do
        let(:end_date_day) { '' }
        let(:end_date_year) { '' }

        it_behaves_like 'an invalid attribute input',
                        :end_date,
                        'End date must include a day and year'
      end

      context 'when month and year are missing' do
        let(:end_date_month) { '' }
        let(:end_date_year) { '' }

        it_behaves_like 'an invalid attribute input',
                        :end_date,
                        'End date must include a month and year'
      end
    end
  end
end
