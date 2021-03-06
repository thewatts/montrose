module Montrose
  module Utils
    module_function

    MONTHS = Date::MONTHNAMES
    DAYS = Date::DAYNAMES

    def month_number(name)
      case name
      when Symbol, String
        MONTHS.index(name.to_s.titleize)
      when 1..12
        name
      end
    end

    def month_number!(name)
      month_number(name) or fail ConfigurationError,
        "Did not recognize month #{name}, must be one of #{MONTHS.inspect}"
    end

    def day_number(name)
      case name
      when 0..6
        name
      when Symbol, String
        DAYS.index(name.to_s.titleize)
      when Array
        day_number name.first
      end
    end

    def day_number!(name)
      day_number(name) or fail ConfigurationError,
        "Did not recognize day #{name}, must be one of #{DAYS.inspect}"
    end
  end
end
