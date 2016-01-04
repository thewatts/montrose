require "spec_helper"

describe Montrose::Clock do
  let(:time_now) { Time.now }

  before do
    Timecop.freeze(time_now)
  end

  describe "#tick" do
    it "must start with given starts time" do
      clock = new_clock(starts: time_now)
      clock.tick.must_equal time_now
    end

    it "emits 1 minute increments" do
      clock = new_clock(every: :minute)

      clock.must_have_tick 1.minute
    end

    it "emits 1 minute increments when smallest part is minute" do
      clock = new_clock(every: :hour, minute: 20)

      clock.must_have_tick 1.minute
    end

    it "emits minute interval increments" do
      clock = new_clock(every: :minute, interval: 30)

      clock.must_have_tick 30.minutes
    end

    it "emits 1 hour increments" do
      clock = new_clock(every: :hour)

      clock.must_have_tick 1.hour
    end

    it "emits 1 hour increments when hour smallest part" do
      clock = new_clock(every: :day, hour: 9..10)

      clock.must_have_tick 1.hour
    end

    it "emits hour interval increments" do
      clock = new_clock(every: :hour, interval: 6)

      clock.must_have_tick 6.hours
    end

    it "emits 1 day increments for :day" do
      clock = new_clock(every: :day)

      clock.must_have_tick 1.day
    end

    it "emits 1 day increments for :mday" do
      clock = new_clock(every: :month, mday: [1, -1])

      clock.must_have_tick 1.day
    end

    it "emits 1 day increments for :yday" do
      clock = new_clock(every: :year, yday: [1, 10, 100])

      clock.must_have_tick 1.day
    end

    it "emits day interval increments" do
      clock = new_clock(every: :day, interval: 3)

      clock.must_have_tick 3.days
    end

    it "emits 1 day iincrements when day smallest part" do
      clock = new_clock(every: :month, day: :tuesday)

      clock.must_have_tick 1.day
    end

    it "emits 1 week increments" do
      clock = new_clock(every: :week)

      clock.must_have_tick 1.week
    end

    it "emits week interval increments" do
      clock = new_clock(every: :week, interval: 2)

      clock.must_have_tick 2.weeks
    end

    it "emits 1 year increments" do
      clock = new_clock(every: :year)

      clock.must_have_tick 1.year
    end

    it "emits year interval increments" do
      clock = new_clock(every: :year, interval: 10)

      clock.must_have_tick 10.years
    end
  end
end
