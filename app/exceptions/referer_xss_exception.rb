# frozen_string_literal: true

##
# Raises exception if checked referer was xss affected.
#
class RefererXssException < ApplicationException
  ##
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException)
  #
  def initialize
    super('Invalid referer header')
  end
end
