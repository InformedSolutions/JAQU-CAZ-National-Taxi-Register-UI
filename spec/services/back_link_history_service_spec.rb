# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BackLinkHistoryService do
  subject { described_class.call(session: session, back_button: back_button, page: page, url: url) }

  let(:session) { {} }
  let(:back_button) { false }
  let(:page) { 1 }
  let(:url) { 'http://www.example.com/vehicles/historic_search' }

  describe '#call' do
    context 'when session is empty and back button is false' do
      it 'returns search url' do
        expect(subject).to include('/vehicles/search')
      end
    end

    context 'when session is empty and back button is true' do
      let(:back_button) { true }

      it 'returns search url' do
        expect(subject).to include('/vehicles/search')
      end

      it 'sets weekly to false' do
        subject
        expect(session[:back_link_history]).to eq({ 1 => 1 })
      end
    end

    context 'when session is not empty and back button is false' do
      let(:session) { { back_link_history: { '1' => 1 } } }
      let(:page) { 4 }

      it 'returns correct page' do
        expect(subject).to include('page=1')
      end

      it 'sets previous number page to the session' do
        subject
        expect(session[:back_link_history]).to eq({ '1' => 1, '2' => 4 })
      end
    end

    context 'when session is not empty and back button is true' do
      let(:session) { { back_link_history: { '1' => 1, '2' => 4 } } }
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('search')
      end

      it 'sets weekly to false' do
        subject
        expect(session[:back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when in session already 10 steps and back button is true' do
      let(:session) { { back_link_history: { '1' => 1, '2' => 4 } } }
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('search')
      end

      it 'sets weekly to false' do
        subject
        expect(session[:back_link_history]).to eq({ '1' => 1 })
      end
    end

    context 'when in session already 10 steps and back button is false' do
      let(:session) do
        {
          back_link_history:
          {
            '1' => 1,
            '2' => 2,
            '3' => 3,
            '4' => 4,
            '5' => 5,
            '6' => 6,
            '7' => 7,
            '8' => 8,
            '9' => 9,
            '10' => 10
          }
        }
      end

      it 'returns correct page' do
        expect(subject).to include('page=10')
      end

      before { subject }

      it 'removes first step and adding next one' do
        expect(session[:back_link_history]).to include({ '11' => 1 })
        expect(session[:back_link_history]).to_not include({ '1' => 1 })
      end
    end

    context 'when in session already 10 steps and back button is true' do
      let(:session) do
        {
          back_link_history:
          {
            '1' => 1,
            '2' => 2,
            '3' => 3,
            '4' => 4,
            '5' => 5,
            '6' => 6,
            '7' => 7,
            '8' => 8,
            '9' => 9,
            '10' => 10
          }
        }
      end
      let(:back_button) { true }

      it 'returns correct page' do
        expect(subject).to include('page=9')
      end

      before { subject }

      it 'not adding the next step' do
        expect(session[:back_link_history]).to include({ '1' => 1 })
        expect(session[:back_link_history]).to include({ '10' => 10 })
        expect(session[:back_link_history]).to_not include({ '11' => 1 })
      end
    end
  end
end
