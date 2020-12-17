# frozen_string_literal: true

# Class to manipulate session and determinate correct page number on the historical results page
class BackLinkHistoryService < BaseService
  # Allow access to url helpers, e.g. search_vehicles_path
  include Rails.application.routes.url_helpers
  # key in session
  KEY = :back_link_history

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +session+ - session object
  # * +back_button+ - boolean, e.g true if back button was used
  # * +page+ - string, page number, eg. '4'
  # * +url+ - string, eg. 'http://www.example.com/vehicles/historic_search?page=4?back=true'
  def initialize(session:, back_button:, page:, url:)
    @session = session
    @back_button = back_button
    @page = page
    @url = url
  end

  # The caller method for the service. It invokes checking back link history and updating it
  #
  # Returns a back link url
  def call
    update_steps_history
    clear_more_then_10_steps
    determinate_back_link_url
  end

  private

  # Creating first step or adding page number to correct step
  def update_steps_history # rubocop:disable Metrics/AbcSize
    if history.nil?
      log_action('Creating first step into the back link history')
      session[KEY] = { '1' => page }
    elsif last_step_page != page
      return clear_unused_steps if back_button && history

      log_action('Adding step to the back link history')
      session[KEY][next_step] = page
    end
  end

  # Removes futures steps when back button was used
  def clear_unused_steps
    log_action('Clearing future steps from the back link history')
    current_step_keys = history.select { |k, _v| k <= previous_step }.keys
    session[KEY] = history.slice(*current_step_keys)
  end

  # Clear first step from history in case if we already have more the 10 steps in the session
  def clear_more_then_10_steps
    session[KEY].shift if history && history.size > 10
  end

  # Returns back link url, e.g '.../vehicles/historic_search?page=3?back=true'
  def determinate_back_link_url
    if history.nil? || history.size == 1
      search_vehicles_path
    else
      "#{url}?page=#{session.dig(KEY, previous_step)}?back=true"
    end
  end

  # Returns previous number of step, e.g '4'
  def previous_step
    (history.keys.last.to_i - 1).to_s
  end

  # Returns the last step page number, e.g 4
  def last_step_page
    history.values.last
  end

  # Returns previous next of step, e.g '5'
  def next_step
    (history.keys.last.to_i + 1).to_s
  end

  # Back link histories from the session
  def history
    session[KEY]
  end

  attr_reader :session, :back_button, :page, :url
end
