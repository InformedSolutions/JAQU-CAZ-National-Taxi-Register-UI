# frozen_string_literal: true

##
# Module used for security checks.
module Security
  ##
  # Service used to prepare check if referer was not affected with javascript included in the request.
  # It uses sanitized links with the referer to check if are correct.
  #
  class RefererXssHandler < BaseService
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +referer+ - string with the request referer.
    #
    def initialize(referer:)
      @referer = referer
    end

    ##
    # Creates html link and checks if referer was not affected with javascript included in the request.
    # If yes, it raise `RefererXssException` exception.
    # If not, return nil.
    def call
      referer_link = link_with_referer(referer)
      sanitized_referer_link = ActionController::Base.helpers.sanitize(referer_link)
      return if referer_link == sanitized_referer_link

      raise RefererXssException
    end

    private

    # Method to create html link tag with referer url
    def link_with_referer(referer)
      ActionController::Base.helpers.link_to('', referer)
    end

    # Attributes reader
    attr_reader :referer
  end
end
