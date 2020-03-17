# frozen_string_literal: true

##
# Class used to display vrn audit logs on the search results page
#
class PaginatedVrnHistory
  # Take data returned from the VehiclesCheckerApi.licence_info_historical
  def initialize(data)
    @data = data
  end

  # Returns an array of VrnHistory model instances
  def vrn_changes_list
    @vrn_changes_list ||= data['changes'].map { |change| VrnHistory.new(change) }
  end

  # Returns current page value
  def page
    data['page'] + 1
  end

  # Returns the number of available pages
  def total_pages
    data['pageCount']
  end

  # Returns the total number of changes
  def total_changes_count
    data['totalChangesCount']
  end

  # Returns the number of changes displayed per page
  def per_page
    data['perPage']
  end

  # Returns the index of the first changes on the page
  def range_start
    page * per_page - (per_page - 1)
  end

  # Returns the index of the last changes on the page
  def range_end
    max = page * per_page
    max > total_changes_count ? total_changes_count : max
  end

  private

  attr_reader :data
end
