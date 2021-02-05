# frozen_string_literal: true

module UserFactory
  def create_user(options = {})
    User.new(
      email: options[:email] || 'test@example.com',
      username: options[:username] || 'test@example.com',
      groups: options[:groups] || %w[ntr.search.dev],
      **account_data(options),
      login_ip: options[:login_ip] || '1.2.3.4'
    )
  end

  private

  def account_data(options)
    {
      preferred_username: options[:preferred_username] || SecureRandom.uuid,
      aws_status: options[:aws_status] || 'OK',
      aws_session: options[:aws_session] || nil,
      hashed_password: options[:hashed_password] || nil
    }
  end
end
