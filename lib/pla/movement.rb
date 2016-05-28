require 'iso_country_codes'

require 'pla/ship'

class PLA
  class Movement
    def initialize record
      # Take a movement record from records and do stuff with it
      @record = record
    end

    def to_h
      normalise_timestamp!
      normalise_ship!
      normalise_country!
      normalise_fields!

      @record
    end

    def normalise_timestamp!
      # The record format from pla has a 'date' field as dd/mm and a time as 'hhmm'
      # We'd prefer a combined timestamp in a standard format

      date = @record.delete :date
      time = @record.delete :time
      now = DateTime.now

      year = now.year
      day,month = date.split('/')
      hour = time[0..1]
      minute = time[2..3]

      date = gen_date year, month, day, hour, minute
      if now > date
        date = gen_date year+1, month, day, hour, minute
      end

      @record[:timestamp] = date
    end

    def normalise_ship!
      name = @record.delete(:'vessel name')
      @record[:vessel] = PLA::Ship.new(name).to_h
    end

    def normalise_country!
      country_code = @record.delete(:nationality)
      begin
        country = IsoCountryCodes.find(country_code).name
      rescue IsoCountryCodes::UnknownCodeError
        STDERR.puts "WARNING: Invalid country code #{country_code.upcase}"
        country = country_code
      end

      @record[:country] = country
    end

    def normalise_fields!
      @record.delete(:at)
    end

    def gen_date year, month, day, hour, minute
      # Because the pla doesn't provide a year we run the risk of providing
      # a date in the past if the data wraps around the end of the year.
      #
      # The pla doesn't, luckily, have data years in advance or this'd be proper
      # fucked
      DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0)
    end


  end
end
