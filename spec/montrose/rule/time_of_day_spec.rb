require "spec_helper"

describe Montrose::Rule::TimeOfDay do
  let(:rule) { Montrose::Rule::TimeOfDay.new([Time.parse("9:00 AM"), Time.parse("3:30 PM")]) }

  describe "#include?" do
    it { assert rule.include?(Time.local(2016, 1, 1, 9)) }
    it { assert rule.include?(Time.local(2016, 2, 2, 9)) }
    it { refute rule.include?(Time.local(2016, 1, 1, 9, 10)) }
    it { refute rule.include?(Time.local(2016, 1, 1, 10)) }
    it { assert rule.include?(Time.local(2016, 1, 1, 15, 30)) }
    it { assert rule.include?(Time.local(2016, 2, 2, 15, 30)) }
    it { refute rule.include?(Time.local(2016, 1, 1, 15, 10)) }
    it { refute rule.include?(Time.local(2016, 1, 1, 14, 30)) }
  end

  describe "#continue?" do
    it { assert rule.continue? }
  end
end
