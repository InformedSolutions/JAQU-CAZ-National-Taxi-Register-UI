# frozen_string_literal: true

shared_examples 'user does not belongs to any group' do
  context 'when user does not belongs to any group' do
    before do
      sign_in create_user(groups: [])
      subject
    end

    it 'redirects to the service unavailable page' do
      expect(response).to redirect_to(service_unavailable_path)
    end
  end
end
