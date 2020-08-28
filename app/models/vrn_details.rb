# frozen_string_literal: true

##
# This class represents data returned by {NTR API endpoint}[rdoc-ref:VehiclesCheckerApi.licence_info]
# and is used to display data in +app/views/vehicles/index.html.haml+.
class VrnDetails
  ##
  # Creates an instance of a class, make +vrn+ uppercase and remove all spaces.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn.upcase.gsub(/\s+/, '')
  end

  # Returns a string, eg. 'CU57ABC'
  def registration_number
    vrn
  end

  # Check 'active' value.
  #
  # Returns a string Taxi or PHV if value is true
  # Returns a string 'No' if value is false
  def taxi_private_hire_vehicle
    if vehicles_checker_api['active']
      vehicles_checker_api['description'].downcase == 'taxi' ? 'Taxi' : 'PHV'
    else
      'No'
    end
  end

  # Check 'wheelchairAccessible' value.
  #
  # Returns '-' if +active+ is false
  # Returns a string 'Yes' if value is true
  # Returns a string 'No' if value is false
  def wheelchair_accessible
    return '-' unless active

    vehicles_checker_api['wheelchairAccessible'] ? 'Yes' : 'No'
  end

  # Returns '-' if +active+ is false
  # Returns string, e.g. 'Birmingham, Leeds'
  def licensing_authorities
    return '-' unless active

    vehicles_checker_api['licensingAuthoritiesNames'].join(', ')
  end

  private

  # Reader function for the vehicle registration number
  attr_reader :vrn

  def vehicles_checker_api
    @vehicles_checker_api ||= VehiclesCheckerApi.licence_info(vrn)
  end

  # Returns boolean
  def active
    vehicles_checker_api['active']
  end
end
