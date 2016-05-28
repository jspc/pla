require 'pla/arrivals'
require 'pla/departures'

class PLA
  def self.arrivals
    PLA::Arrivals.new.records
  end

  def self.departures
    PLA::Departures.new.records
  end
end
