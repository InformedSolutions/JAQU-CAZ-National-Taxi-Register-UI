# frozen_string_literal: true

class NewPasswordForm < BaseForm
  attr_reader :password, :confirmation, :old_password_hash

  def initialize(password:, confirmation:, old_password_hash:)
    @password = password
    @confirmation = confirmation
    @old_password_hash = old_password_hash
    super(nil)
  end

  def valid?
    filled? && password_changed? && correct_password_confirmation?
  end

  private

  def filled?
    return true if password.present? && confirmation.present?

    @message = I18n.t('password.errors.password_required')
    false
  end

  def password_changed?
    return true if old_password_hash && Digest::MD5.hexdigest(password) != old_password_hash

    @message = I18n.t('password.errors.password_unchanged')
    false
  end

  def correct_password_confirmation?
    return true if password == confirmation

    @message = I18n.t('password.errors.password_equality')
    false
  end
end
