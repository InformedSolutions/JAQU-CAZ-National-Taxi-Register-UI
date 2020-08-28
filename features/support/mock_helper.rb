# frozen_string_literal: true

# Methods used to parse the json files
module MockHelper
  # Reads provided file from +spec/fixtures/files+ directory
  def read_response_file(filename)
    JSON.parse(File.read("spec/fixtures/files/responses/#{filename}"))
  end
end

World(MockHelper)
