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
  base_uri API_URL + '/v1/vehicles'

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
    # rubocop:disable Lint/UnusedMethodArgument:
    def licence_info_historical(vrn:, page:, per_page: 10)
      log_call("Getting the historical details for page: #{page}")

      mocked_vrn_history(page)

      # query = { 'pageNumber' => page - 1, 'pageSize' => per_page }
      # request(:get, "/#{vrn}/licence-info-historical", query: query)
    end
    # rubocop:enable Lint/UnusedMethodArgument:

    private

    def mocked_vrn_history(page = 1)
      if page == 1
        read_response_file('licence_info_historical_response.json')['1']
      elsif page == 2
        read_response_file('licence_info_historical_response.json')['2']
      else
        { 'perPage' => 10, 'page' => page, 'pageCount' => 2, 'totalChangesCount' => 12,
          'changes' => [] }
      end
    end

    def read_response_file(filename)
      JSON.parse(File.read("spec/fixtures/files/responses/#{filename}"))
    end
  end
end
