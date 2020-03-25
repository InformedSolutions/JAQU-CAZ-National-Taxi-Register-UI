# frozen_string_literal: true

##
# Represents the virtual model of the vrn history.
#
class VrnHistory
  # Initializer method.
  #
  # ==== Params
  # * +data+ - hash
  #   * +modifyDate+ - string, date format
  #   * +action+ - string, status of current VRM for a specific date range
  #   * +licensingAuthorityName+ - array of strings, containing the licensing authority names
  #   * +plateNumber+ - string, a vehicle registration plate
  #   * +licenceStartDate+ - string, date format
  #   * +licenceEndDate+ - string, date format
  #   * +wheelchairAccessible+ -  boolean, wheelchair accessible by any active operating licence
  #
  def initialize(data)
    @data = data
  end

  # returns date, e.g. '22/06/2020'
  def data_upload_date
    formatted_timestamp(data['modifyDate'])
  end

  # returns string, e.g. 'Updated'
  # returns `Added` if value is 'Created'
  def action
    value = data['action'].capitalize
    value == 'Created' ? 'Added' : value
  end

  # returns string, e.g. 'Leeds'
  def licensing_authority
    data['licensingAuthorityName']
  end

  # returns string, e.g. 'CU12345'
  def plate_number
    data['plateNumber'].upcase
  end

  # returns date, e.g. '22/06/2020'
  def licence_start_date
    formatted_timestamp(data['licenceStartDate'])
  end

  # returns date, e.g. '22/06/2020'
  def licence_end_date
    formatted_timestamp(data['licenceEndDate'])
  end

  # Check 'wheelchairAccessible' value.
  #
  # Returns a string 'Yes' if value is true
  # Returns a string 'No' if value is false or nil
  def wheelchair_accessible
    data['wheelchairAccessible'] ? 'Yes' : 'No'
  end

  private

  # Reader for data hash
  attr_reader :data

  # returns formatted date, e.g. '22/06/2020'
  def formatted_timestamp(date)
    Date.parse(date).strftime('%d/%m/%Y')
  end
end
