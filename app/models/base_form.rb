# frozen_string_literal: true

class BaseForm
  attr_reader :parameter, :message, :error_input

  def initialize(parameter)
    @parameter = parameter
    @message = ''
    @error_input = ''
    valid?
  end
end
