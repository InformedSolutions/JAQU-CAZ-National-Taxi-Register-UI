# frozen_string_literal: true

module MockHelper
  # Reads provided file from +spec/fixtures/files+ directory
  def read_response_file(filename)
    JSON.parse(File.read("spec/fixtures/files/responses/#{filename}"))
  end

  # Reads provided file from +spec/fixtures/responses+ directory
  def read_unparsed_response(filename)
    File.read("spec/fixtures/files/responses/#{filename}")
  end
end
