require 'iso_country_codes'

class PLA
  class Vessel
    def initialize name, country, agent
      @name = name
      @country = normalise_country(country)
      @agent = agent
    end

    def to_h
      {
        name: @name,
        country: @country,
        agent: @agent,
        google: "https://www.google.co.uk/search?q=site:vesselfinder.com #{@name}"
      }
    end

    def normalise_country country_code
      begin
        country = IsoCountryCodes.find(country_code).name
      rescue IsoCountryCodes::UnknownCodeError
        STDERR.puts "WARNING: Invalid country code #{country_code.upcase}"
        country = country_code
      end

      country
    end

  end
end
