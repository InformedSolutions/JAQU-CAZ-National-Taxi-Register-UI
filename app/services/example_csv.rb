# frozen_string_literal: true

class ExampleCsv < BaseService
  attr_reader :lines, :dir

  def initialize(lines:, dir: 'tmp/example_files')
    @lines = lines
    @dir = dir
  end

  def call
    FileUtils.mkdir_p(dir)
    CSV.open(file_name, 'wb') do |csv|
      lines.times do
        csv << [random_vrn, *random_time_range, type, la, random_plate, wheelchair?]
      end
    end
  end

  private

  def file_name
    "#{dir}/CAZ-#{Date.current.iso8601}-ABCDE-#{lines}.csv"
  end

  def random_vrn
    ([*('A'..'Z')].sample(3) + [*(0..9)].sample(3)).join
  end

  def random_time_range
    i = [*(3..20)].sample
    [(Date.current - i.months).iso8601, (Date.current + i.months).iso8601]
  end

  def type
    %w[taxi PHV].sample
  end

  def la
    %w[Birmingham Leeds].sample
  end

  def random_plate
    [*('a'..'z'), *('A'..'Z')].sample(5).join
  end

  def wheelchair?
    [true, false].sample
  end
end
