# frozen_string_literal: true

module ApplicationHelper
  def current_path?(path)
    if request.path_info == path
      'govuk-header__navigation-item--active'
    end
  end
end
