require 'time'
require 'nokogiri'
require 'open-uri'

require 'pla/movement'

class PLA
  class Movements
    class << self
      attr_accessor :url
      def set_url u
        @url = u
      end
    end

    attr_reader :records, :headers

    def initialize
      @url = self.class.url
      @root = 'div.newsMainArea table tr td table tr'  # It gets worse

      @records = []
      @ships = get_ships_data

      set_headers
      set_records

      @records
    end

    def get_ships_data
      Nokogiri::HTML(open(@url)).css(@root)
    end

    def set_headers
      @headers = normalize_and_map(@ships.first.css('th'))
      @headers[-1] = 'Notes'  # pla returns this as empty. We infer it means notes, though usually it says 'Pilot required'
    end

    def set_records
      @ships[1..-1].each do |t|
        record = {}
        fields = normalize_and_map(t.css('td'))
        fields.each_with_index do |f,i|
          record[ @headers[i].to_sym ] = f
        end

        movement = PLA::Movement.new(record)
        @records << movement.to_h
      end
    end

    private
    def normalize_and_map elem
      # This is a mess- the pla website wraps a date with non-breaking spaces
      # and some other stuff with normal whitespace. We don't want this because
      # it is a mess. Thus we convert nbsp chars (ord 160) with spaces (ord 32)
      # and then allow strip to tidy the rest up.

      nbsp = Nokogiri::HTML("&nbsp;").text
      elem.map{|c| c.text.gsub(nbsp, ' ').strip.downcase}
    end
  end
end
