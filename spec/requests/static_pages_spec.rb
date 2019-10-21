# frozen_string_literal: true

require 'rails_helper'

describe StaticPagesController, type: :request do
  describe 'GET #accessibility' do
    subject(:http_request) { get accessibility_static_pages_path }

    it_behaves_like 'a static page'
  end

  describe 'GET #cookies' do
    subject(:http_request) { get cookies_static_pages_path }

    it_behaves_like 'a static page'
  end

  describe 'GET #privacy_policy' do
    subject(:http_request) { get privacy_policy_static_pages_path }

    it_behaves_like 'a static page'
  end
end
