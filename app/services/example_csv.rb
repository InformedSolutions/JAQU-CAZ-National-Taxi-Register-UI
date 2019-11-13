# frozen_string_literal: true

##
# This class is used to create example, valid CSV file with the desired number of rows
# (1000 in the example below) by calling in rails console ExampleCsv.call(lines: 1000).
# It will be created in tmp/example_files directory, which can be overridden by setting dir param
# in the caller.
#
# ==== Usage
#
#     ExampleCsv.call(lines: 1, dir: 'my_new_dir')
class ExampleCsv < BaseService
  # Variables used internally by the service
  attr_reader :lines, :dir

  ##
  # Initializer method.
  #
  # ==== Attributes
  #
  # * +lines+ - integer
  # * +dir+ - string, dir name eg. 'my_new_dir'
  def initialize(lines:, dir: 'tmp/example_files')
    @lines = lines
    @dir = dir
  end

  # The caller method for the service. It invokes creating csv files.
  #
  # Returns a integer, number of created files.
  def call
    FileUtils.mkdir_p(dir)
    CSV.open(file_name, 'wb') do |csv|
      lines.times do
        csv << [random_vrn, *random_time_range, type, la, random_plate, wheelchair?]
      end
    end
  end

  private

  # Returns a string, proper filename, eg. 'tmp/example_files_test/CAZ-2019-09-19-ABCDE.csv'
  def file_name
    "#{dir}/CAZ-#{Date.current.iso8601}-ABCDE.csv"
  end

  # Returns a string, random vrn in the proper format, eg. 'NWF218'
  def random_vrn
    ([*('A'..'Z')].sample(3) + [*(0..9)].sample(3)).join
  end

  # Returns an array, random time range, eg. ["2019-03-19", "2020-03-19"]
  def random_time_range
    i = [*(3..20)].sample
    [(Date.current - i.months).iso8601, (Date.current + i.months).iso8601]
  end

  # Returns a random element from the array.
  def type
    %w[taxi PHV].sample
  end

  # Returns a random element from the array.
  def la
    %w[Birmingham Leeds].sample
  end

  # Returns a random string from the array, eg. 'gYjpk'
  def random_plate
    [*('a'..'z'), *('A'..'Z')].sample(5).join
  end

  # Returns a random element as a boolean value from the array.
  def wheelchair?
    [true, false].sample
  end
end
