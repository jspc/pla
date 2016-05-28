require 'pla/movements'

class PLA
  class Arrivals < Movements
    set_url 'https://www.pla.co.uk/Port-Trade/Ship-movements/Ship-movements?flag=5'
  end
end
