require "coveralls"
Coveralls.wear! do
  add_filter "spec/support"
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "montrose"

require "minitest/autorun"
require "minitest/pride" # awesome colorful output

require "timecop"

begin
  require "pry"
rescue LoadError
end

Dir[File.expand_path("../../spec/support/**/*.rb", __FILE__)].each { |f| require f }

module Minitest
  class Spec
    def new_schedule(options = {})
      schedule = Montrose::Schedule.new
      schedule << options if options.any?
      schedule
    end

    def new_recurrence(options = {})
      Montrose::Recurrence.new(options)
    end

    def new_clock(options = {})
      Montrose::Clock.new({ starts: time_now }.merge(options))
    end

    def new_frequency(options = {})
      Montrose::Frequency.from_options({ starts: time_now }.merge(options))
    end

    def new_options(options = {})
      Montrose::Options.new(options)
    end

    def to_time(obj)
      Time.zone.parse(obj)
    end

    def time_now
      Time.now
    end

    def consecutive_days(count, starts: time_now, interval: 1)
      consecutive(:days, count, starts: starts, interval: interval)
    end

    def consecutive(duration, count, starts: time_now, interval: 1)
      [].tap do |e|
        date = starts.to_time
        count.times do
          e << date
          date += interval.send(duration)
        end
      end
    end

    def cherry_pick(date_hash)
      date_hash.flat_map do |year, months|
        months.flat_map do |month, days|
          days.flat_map do |day|
            Time.new(year, month, day)
          end
        end
      end
    end
  end

  module Assertions
    def assert_pairs_with(expected_enum, actual_enum)
      expected_enum.zip(actual_enum).each_with_index do |(expected, actual), i|
        assert !actual.nil?, "Expected #{expected} but got nil at position #{i}"
        assert_equal expected.change(usec: 0), actual.change(usec: 0),
          "Expected #{expected} but got #{actual} at position #{i}"
      end
    end

    def assert_interval(actual_duration, given_enum)
      first = given_enum.next
      second = given_enum.next
      assert_equal actual_duration.to_i, (second - first).to_i
    end

    def assert_tick(actual_duration, clock)
      first = clock.tick
      second = clock.tick
      assert_equal second.change(usec: 0), (first + actual_duration).change(usec: 0)
    end
  end
end

Array.infect_an_assertion :assert_pairs_with, :must_pair_with
Enumerator.infect_an_assertion :assert_pairs_with, :must_pair_with
Enumerator.infect_an_assertion :assert_interval, :must_have_interval
Montrose::Clock.infect_an_assertion :assert_tick, :must_have_tick
