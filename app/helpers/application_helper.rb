# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation.
#
module ApplicationHelper
  # Returns a 'govuk-header__navigation-item--active' if current path equals a new path.
  def current_path?(path)
    'govuk-header__navigation-item--active' if request.path_info == path
  end

  # Returns name of service, eg. 'Taxi and PHV Data Portal'.
  def service_name
    Rails.configuration.x.service_name
  end

  # Returns Support service email, eg. 'TaxiPHVDatabase.Support@informed.com'.
  def support_service_email
    Rails.configuration.x.support_service_email
  end

  # Returns configured contact email address, eg. 'TaxiandPHVCentralised.Database@defra.gov.uk'.
  def service_email
    Rails.configuration.x.service_email
  end

  # Remove duplicated error messages, e.g. `Email and email address confirmation must be the same`
  def remove_duplicated_messages(errors)
    transformed_errors(errors).uniq(&:first)
  end

  # Transform hash of errors:
  # {
  #   :email_confirmation=>["Email confirmation is in an invalid format", "Email and email address confirmation must be the same"],
  #   :email=>["Email and email address confirmation must be the same"]
  # }
  # to array:
  # [
  #   ["Email confirmation is in an invalid format", :email_confirmation],
  #   ["Email and email address confirmation must be the same",:email_confirmation],
  #   ["Email and email address confirmation must be the same", :email]
  # ]
  #
  def transformed_errors(errors)
    errors.map { |error| error.second.map { |msg| [msg, error.first] } }.flatten(1)
  end

  # Used for external inline links in the app.
  # Returns a link with blank target and area-label.
  #
  # Reference: https://www.w3.org/WAI/GL/wiki/Using_aria-label_for_link_purpose
  def external_link_to(text, url, html_options = {})
    html_options.symbolize_keys!.reverse_merge!(
      target: '_blank',
      class: 'govuk-link',
      rel: 'noopener',
      'aria-label': "#{html_options[:'aria-label'] || text} (#{I18n.t('external_link')})"
    )

    link_to "#{text} (#{I18n.t('external_link')})", url, html_options
  end
end
