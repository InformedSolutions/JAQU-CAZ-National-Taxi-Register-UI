# frozen_string_literal: true

##
# Controller class for search vrn's in database
#
class VehiclesController < ApplicationController
  # 404 HTTP status from API mean vehicle in not found in database. Redirects to the not found page.
  rescue_from BaseApi::Error404Exception, with: :vrn_not_found
  # checks if a user is logged in
  before_action :authenticate_user!
  # checks if VRN is present in the session
  before_action :check_vrn, only: %i[index]
  # assign back button path
  before_action :assign_back_button_url, only: %i[index search not_found]

  ##
  # Renders the search page
  #
  # ==== Path
  #    :GET /vehicles/search
  #
  def search
    @errors = nil
  end

  ##
  # Validates submitted VRN. If successful, redirects to {details}[rdoc-ref:index].
  #
  # Any invalid params values triggers rendering {search page}[rdoc-ref:search] with @errors
  # displayed.
  #
  # ==== Path
  #    :POST /vehicles/submit_search
  #
  def submit_search
    form = VrnForm.new(params[:vrn])
    unless form.valid?
      @errors = form.errors.messages[:vrn]
      return render :search
    end

    session[:vrn] = parsed_vrn(params[:vrn])
    redirect_to vehicles_path
  end

  ##
  # Renders search results page
  #
  # ==== Path
  #    :GET /vehicles
  #
  def index
    @vrn_details = VrnDetails.new(vrn)
  end

  ##
  # Renders not found page
  #
  # ==== Path
  #    :GET /vehicles/not_found
  #
  def not_found
    # renders static page
  end

  private

  # Returns uppercased VRN from the query params without any space, eg. 'CU1234'
  def parsed_vrn(params_vrn)
    @parsed_vrn ||= params_vrn.upcase&.delete(' ')
  end

  # Redirects to {vehicle not found}[rdoc-ref:VehiclesController.not_found]
  def vrn_not_found
    redirect_to not_found_vehicles_path
  end

  # Checks if VRN is present in session.
  # If not, redirects to VehiclesController#search
  def check_vrn
    return if vrn

    redirect_to search_vehicles_path
  end

  # Gets VRN from session. Returns string, eg 'CU1234'
  def vrn
    session[:vrn]
  end
end
