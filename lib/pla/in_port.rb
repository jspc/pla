require 'pla/movements'

class PLA
  class InPort < Movements
    set_url 'https://www.pla.co.uk/Port-Trade/Ship-movements/Ship-movements?flag=7'
  end
end
