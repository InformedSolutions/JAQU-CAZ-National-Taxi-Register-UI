# frozen_string_literal: true

module UserFactory
  def create_user(options = {})
    User.new(
      email: options[:email] || 'test@example.com',
      username: options[:username] || 'test@example.com',
      groups: options[:groups] || %w[ntr.search.dev],
      **account_data(options),
      login_ip: options[:login_ip] || @remote_ip
    )
  end

  private

  def account_data(options)
    {
      sub: options[:sub] || SecureRandom.uuid,
      aws_status: options[:aws_status] || 'OK',
      aws_session: options[:aws_session] || nil,
      hashed_password: options[:hashed_password] || nil
    }
  end
end
