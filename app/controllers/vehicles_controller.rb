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
  before_action :assign_back_button_url, only: %i[index not_found historic_search]

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
    form = SearchVrnForm.new(adjusted_search_params)
    unless form.valid?
      @errors = form.errors.messages
      return render :search
    end

    session[:vrn] = form.vrn
    determinate_results_page(form)
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
    @vrn_details = HistoricalVrnDetails.new(vrn, page, start_date, end_date)
    @vrn = vrn
    @pagination = @vrn_details.pagination
    @return_url = determinate_back_link_url(page)
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

  # Gets Start Date from session. Returns string, eg '2010-01-01'
  def start_date
    session[:start_date]
  end

  # Gets End Date from session. Returns string, eg '2020-03-24'
  def end_date
    session[:end_date]
  end

  # Returns the list of permitted params and uppercased +vrn+ without any space, eg. 'CU1234'
  def adjusted_search_params
    strong_params = params.require(:search).permit(
      :vrn, :historic, :start_date_day, :start_date_month, :start_date_year, :end_date_day,
      :end_date_month, :end_date_year
    )
    strong_params['vrn'] = strong_params['vrn']&.upcase&.delete(' ')
    strong_params
  end

  # Returns redirect to the results page depending on the +historic+ value
  def determinate_results_page(form)
    if form.historic == 'true'
      session[:start_date] = form.start_date
      session[:end_date] = form.end_date
      session[:back_link_history] = nil
      redirect_to historic_search_vehicles_path
    else
      redirect_to vehicles_path
    end
  end

  # Returns back link url, e.g '.../vehicles/historic_search?page=3?back=true'
  def determinate_back_link_url(page)
    BackLinkHistoryService.call(
      session: session,
      back_button: back_button_used?,
      page: page,
      url: historic_search_vehicles_url
    )
  end

  def back_button_used?
    request.query_parameters['page']&.include?('back')
  end
end
