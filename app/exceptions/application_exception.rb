# frozen_string_literal: true

class ApplicationException < StandardError
  attr_reader :errors
end
