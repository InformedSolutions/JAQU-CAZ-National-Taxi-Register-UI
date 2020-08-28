# frozen_string_literal: true

# Methods used to manipulate the session data in rspec tests
module SessionHelper
  def add_vrn_to_session
    page.set_rack_session(vrn: vrn)
  end

  private

  def vrn
    'CU57ABC'
  end
end

World(SessionHelper)
