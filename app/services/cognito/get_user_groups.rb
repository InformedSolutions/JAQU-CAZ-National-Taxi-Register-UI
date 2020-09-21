# frozen_string_literal: true

##
# Module used to wrap communication with Amazon Cognito
module Cognito
  ##
  # Class responsible for requesting a Cognito service to get user groups
  #
  class GetUserGroups < CognitoBaseService
    ##
    # Initializer method for the service.
    #
    # ==== Attributes
    # * +username+ - string, user email address
    def initialize(username:)
      @username = username
    end

    ##
    # Perform the call to Cognito service to get user groups
    def call
      admin_list_groups_for_user
    end

    private

    # Variable used internally by the service
    attr_reader :username

    # Perform the call to Cognito service to get user groups
    def admin_list_groups_for_user
      log_action('Getting the groups that the user belongs to')
      client.admin_list_groups_for_user({ user_pool_id: user_pool_id, username: username })
    end
  end
end
