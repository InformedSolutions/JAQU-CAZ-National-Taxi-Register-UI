# frozen_string_literal: true

##
# This is an abstract class used as a base form by all form classes with multiple attributes.
#
class MultipleAttributesBaseForm
  include ActiveModel::Validations

  # Overrides default initializer for compliance with form_for method in views
  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  # Used in search vrn view and should return nil when the object is not persisted.
  def to_key
    nil
  end
end
