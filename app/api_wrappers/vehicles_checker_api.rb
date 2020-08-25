# frozen_string_literal: true

##
# This class wraps calls being made to the NTR backend API.
# The base URL for the calls is configured by +TAXI_PHV_REGISTER_API_URL+ environment variable.
#
# All calls have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.
class VehiclesCheckerApi < BaseApi
  API_URL = ENV.fetch('TAXI_PHV_REGISTER_API_URL', 'localhost:3001').freeze
  base_uri "#{API_URL}/v1/vehicles"

  headers(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-Correlation-ID' => -> { SecureRandom.uuid }
  )

  class << self
    ##
    # Calls +/v1/vehicles/:vrn/licence-info+ endpoint with +GET+ method
    # and returns the list of license details.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number, eg. 'CU12345'
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +active+ - boolean, eg. true
    # * +wheelchairAccessible+ - boolean, eg. false
    # * +licensingAuthoritiesNames+ - array of strings, list of LA where vehicle is registered as a taxi,
    #   eg. ["Birmingham", "Leeds"]
    #
    def licence_info(vrn)
      log_call('Getting vehicle details')
      request(:get, "/#{vrn}/licence-info")
    end

    ##
    # Calls +/v1/vehicles/:vrn/licence-info-historical+ endpoint with +GET+ method
    # and returns paginated list of vehicle's information
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number, eg. 'CU12345'
    # * +page+ - requested page of the results
    # * +per_page+ - number of vehicles per page, defaults to 10
    # * +start_date+ - string, date format, eg '2010-01-01'
    # * +end_date+ - string, date format, eg '2020-03-24'
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +page+ - number of available pages
    # * +pageCount+ - number of available pages
    # * +perPage+ - number of available pages
    # * +totalChangesCount+ - integer, the total number of changes associated with this vehicle
    # * +changes+ - array of objects, history of changes for current vrn
    #   * +modifyDate+ - string, date format
    #   * +action+ - string, status of current VRM for a specific date range
    #   * +licensingAuthorityName+ - array of strings, containing the licensing authority names
    #   * +plateNumber+ - string, A vehicle registration plate
    #   * +licenceStartDate+ - string, date format
    #   * +licenceEndDate+ - string, date format
    #   * +wheelchairAccessible+ -  boolean, wheelchair accessible by any active operating licence
    #
    def licence_info_historical(vrn:, page:, per_page: 10, start_date:, end_date:)
      log_call("Getting the historical details for page: #{page}, start_date: #{start_date}"\
               " and end_date: #{end_date}")

      query = {
        'pageNumber' => calculate_page_number(page),
        'pageSize' => per_page,
        'startDate' => start_date,
        'endDate' => end_date
      }

      request(:get, "/#{vrn}/licence-info-historical", query: query)
    end

    private

    def calculate_page_number(page)
      result = page - 1
      result.negative? ? 0 : result
    end
  end
end
