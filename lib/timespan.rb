require 'time_extensions'

class Timespan
  attr_reader :total_years, :total_months, :total_days, :total_hours, :total_minutes, :total_seconds,
              :years, :months, :days, :hours, :minutes, :seconds

  def initialize(seconds)
    @total_seconds = seconds
    @total_minutes = seconds/60
    @total_hours = @total_minutes/60
    @total_days = @total_hours/24
    @total_years = @total_days/365.25
    @total_months = @total_years*12


    components = Timespan.get_time_diff_components(%w(year month week day hour minute second), seconds)
    @years = components[0]
    @months = components[1]
    @weeks = components[2]
    @days = components[3]
    @hours = components[4]
    @minutes = components[5]
    @seconds = components[6]
  end

  def to_format(format_string='%y, %M, %w, %d and %h:%m:%s')
    formatted_intervals = Timespan.get_formatted_intervals(format_string)
    #return formatted_intervals.to_yaml
    components = Timespan.get_time_diff_components(formatted_intervals, @total_seconds)
    formatted_components = Timespan.create_formatted_component_hash(components, formatted_intervals)
    format_string = Timespan.remove_format_string_for_zero_components(formatted_components, format_string)
    Timespan.format_date_time(formatted_components, format_string) unless format_string.nil?
  end

  private

  def self.get_formatted_intervals(format_string)
    intervals = []
    intervals << 'year' if format_string.include?('%y')
    intervals << 'month' if format_string.include?('%M')
    intervals << 'week' if format_string.include?('%w')
    intervals << 'day' if format_string.include?('%d')
    intervals << 'hour' if format_string.include?('%h') || format_string.include?('%H')
    intervals << 'minute' if format_string.include?('%m') || format_string.include?('%N')
    intervals << 'second' if format_string.include?('%s') || format_string.include?('%S')
    intervals
  end

  def self.create_formatted_component_hash(components, formatted_intervals)
    formatted_components = {}
    index = 0
    components.each do |component|
      formatted_components[:"#{formatted_intervals[index]}"] = component
      index = index + 1
    end
    formatted_components
  end

  def self.get_time_diff_components(intervals, duration_in_seconds)
    components = []
    intervals.each do |interval|
      component = (duration_in_seconds / 1.send(interval)).floor
      duration_in_seconds -= component.send(interval)
      components << component
    end
    components
  end

  def self.format_date_time(time_diff_components, format_string)
    format_string.gsub!('%y', "#{time_diff_components[:year]} #{pluralize('year', time_diff_components[:year])}") if time_diff_components[:year]
    format_string.gsub!('%M', "#{time_diff_components[:month]} #{pluralize('month', time_diff_components[:month])}") if time_diff_components[:month]
    format_string.gsub!('%w', "#{time_diff_components[:week]} #{pluralize('week', time_diff_components[:week])}") if time_diff_components[:week]
    format_string.gsub!('%d', "#{time_diff_components[:day]} #{pluralize('day', time_diff_components[:day])}") if time_diff_components[:day]
    format_string.gsub!('%H', "#{time_diff_components[:hour]} #{pluralize('hour', time_diff_components[:hour])}") if time_diff_components[:hour]
    format_string.gsub!('%N', "#{time_diff_components[:minute]} #{pluralize('minute', time_diff_components[:minute])}") if time_diff_components[:minute]
    format_string.gsub!('%S', "#{time_diff_components[:second]} #{pluralize('second', time_diff_components[:second])}") if time_diff_components[:second]
    format_string.gsub!('%h', format_digit(time_diff_components[:hour]).to_s) if time_diff_components[:hour]
    format_string.gsub!('%m', format_digit(time_diff_components[:minute]).to_s) if time_diff_components[:minute]
    format_string.gsub!('%s', format_digit(time_diff_components[:second]).to_s) if time_diff_components[:second]
    format_string
  end

  def self.pluralize(word, count)
    return count != 1 ? word.pluralize : word
  end

  def self.remove_format_string_for_zero_components(time_diff_components, format_string)
    format_string.gsub!('%y, ', '') if time_diff_components[:year] == 0
    format_string.gsub!('%M, ', '') if time_diff_components[:month] == 0
    format_string.gsub!('%w, ', '') if time_diff_components[:week] == 0
    if format_string.slice(0..1) == '%d'
      format_string.gsub!('%d ', '') if time_diff_components[:day] == 0
    else
      format_string.gsub!(', %d', '') if time_diff_components[:day] == 0
    end
    format_string.slice!(0..3) if format_string.slice(0..3) == 'and '
    format_string
  end

  def self.format_digit(number)
    return '%02d' % number
  end
end