require 'pla/vessel'

class PLA
  class Movement
    def initialize record
      # Take a movement record from records and do stuff with it
      @record = record
    end

    def to_h
      normalise_timestamp!
      normalise_vessel!
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

    def normalise_vessel!
      name = @record.delete(:'vessel name')
      country = @record.delete(:nationality)
      agent = @record.delete(:agent)

      @record[:vessel] = PLA::Vessel.new(name, country, agent).to_h
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
