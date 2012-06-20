require 'helper'
require 'time'

class TestTimeDiff < Test::Unit::TestCase
  should "return the time difference in displayable format" do
    assert_test_scenarios(Time.utc(2011,3,6),             Time.utc(2011,3,7), {:year => 0, :month => 0, :week => 0, :day => 1, :hour => 0, :minute => 0, :second => 0, :diff => '1 day and 00:00:00'})
    assert_test_scenarios(Time.utc(2011,3,6),             Time.utc(2011,4,8), {:year => 0, :month => 1, :week => 0, :day => 3, :hour => 0, :minute => 0, :second => 0, :diff => '1 month, 3 days and 00:00:00'})
    assert_test_scenarios(Time.utc(2011,3,6,12,30,00),    Time.utc(2011,03,07,12,30,30), {:year => 0, :month => 0, :week => 0, :day => 1, :hour => 0, :minute => 0, :second => 30, :diff => '1 day and 00:00:30'})
    assert_test_scenarios(Time.utc(2011,03,06),           Time.utc(2013,03,07), {:year => 2, :month => 0, :week => 0, :day => 1, :hour => 12, :minute => 0, :second => 0, :diff => '2 years, 1 day and 12:00:00'})
    assert_test_scenarios(Time.utc(2011,03,06),           Time.utc(2011,03,14), {:year => 0, :month => 0, :week => 1, :day => 1, :hour => 0, :minute => 0, :second => 0, :diff => '1 week, 1 day and 00:00:00'})
    assert_test_scenarios(Time.utc(2011,03,06,12,30,00),  Time.utc(2011,03,06,12,30,30), {:year => 0, :month => 0, :week => 0, :day => 0, :hour => 0, :minute => 0, :second => 30, :diff => '00:00:30'})
  end

  should "return the time difference in a formatted text" do
    assert_test_scenarios_for_formatted_diff(Time.parse('2010-03-06 12:30:00'), Time.parse('2011-03-07 12:30:30'), '%y, %d and %h:%m:%s', '1 year and 18:00:30')
    assert_test_scenarios_for_formatted_diff(Time.parse('2010-03-06 12:30:00'), Time.parse('2011-03-07 12:30:30'), '%d %H %N %S', '366 days 0 hours 0 minutes 30 seconds')
    assert_test_scenarios_for_formatted_diff(Time.parse('2011-03-06 12:30:00'), Time.parse('2011-03-07 12:30:30'), '%H %N %S', '24 hours 0 minutes 30 seconds')
  end

  def assert_test_scenarios(start_date, end_date, expected_result)
    date_diff = Time.diff(start_date, end_date)
    assert_equal(date_diff.years, expected_result[:year], "Years aren't equal")
    assert_equal(date_diff.months, expected_result[:month], "Months are wrong")
    assert_equal(date_diff.days, expected_result[:day], "Days aren't equal")
    assert_equal(date_diff.hours, expected_result[:hour], "Hours aren't equal: #{start_date} ->#{end_date}")
    assert_equal(date_diff.minutes, expected_result[:minute], "Minutes aren't equal")
    assert_equal(date_diff.seconds, expected_result[:second], "Seconds aren't equal")
  end

  def assert_test_scenarios_for_formatted_diff(start_date, end_date, format_string, expected_result)
    date_diff = Time.diff(start_date, end_date)
    assert_equal(date_diff.to_format(format_string), expected_result, "Format wrong")
  end
end
