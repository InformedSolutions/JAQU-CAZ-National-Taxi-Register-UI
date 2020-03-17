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
  before_action :check_vrn, only: %i[index historic_search]
  # assign back button path
  before_action :assign_back_button_url, only: %i[index search not_found historic_search]

  ##
  # Renders the search page
  #
  # ==== Path
  #    :GET /vehicles/search
  #
  def search
    @errors = {}
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
    form = SearchVrnForm.new(search_params)
    unless form.valid?
      @errors = form.errors.messages
      return render :search
    end

    session[:vrn] = parsed_vrn(form.vrn)
    determinate_results_page(form.historic)
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
  # Renders the historical results page
  #
  # ==== Path
  #    :GET /vehicles/historic_search
  #
  def historic_search
    page = (params[:page] || 1).to_i
    @vrn_details = HistoricalVrnDetails.new(vrn, page)
    @vrn = vrn
    @pagination = @vrn_details.pagination
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

  # Returns the list of permitted params
  def search_params
    params.require(:search).permit(
      :vrn,
      :historic,
      :start_date_day,
      :start_date_month,
      :start_date_year,
      :end_date_day,
      :end_date_month,
      :end_date_year
    )
  end

  # Returns redirect to the results page depending on the +historic+ value
  def determinate_results_page(historic)
    if historic == 'true'
      redirect_to historic_search_vehicles_path
    else
      redirect_to vehicles_path
    end
  end
end
