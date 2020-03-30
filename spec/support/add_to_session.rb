# frozen_string_literal: true

module AddToSession
  def add_to_session(data = {})
    encoded_data = RackSessionAccess.encode(data.stringify_keys)
    put RackSessionAccess.path, params: { data: encoded_data }
  end
end
