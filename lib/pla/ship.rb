class PLA
  class Ship
    def initialize ship
      @name = ship
    end

    def to_h
      {
        name: @name,
        google: "https://www.google.co.uk/search?q=site:vesselfinder.com #{@name}"
      }
    end
  end
end
