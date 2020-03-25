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
  end
end
