require 'rubygems'
require 'active_support/all'

class Time
  def self.diff(start_date, end_date)
    start_time = start_date.to_time if start_date.respond_to?(:to_time)
    end_time = end_date.to_time if end_date.respond_to?(:to_time)
    duration_in_seconds = ((end_time - start_time).abs).round
    Timespan.new(duration_in_seconds)
  end
end