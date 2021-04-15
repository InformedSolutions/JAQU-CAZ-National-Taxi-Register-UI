# frozen_string_literal: true

module UploadHelper
  # TO DO: Remove when new release of rails will fix 'fixture_file_upload' method error
  # https://github.com/rspec/rspec-rails/issues/2439
  def fixture_file_upload(path)
    Rack::Test::UploadedFile.new(path)
  end
end
