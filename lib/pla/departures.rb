require 'pla/movements'

class PLA
  class Departures < Movements
    set_url 'https://www.pla.co.uk/Port-Trade/Ship-movements/Ship-movements?flag=6'
  end
end
