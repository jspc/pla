require 'pla/arrivals'
require 'pla/departures'

class PLA
  def self.arrivals
    PLA::Arrivals.new.records
  end

  def self.departures
    PLA::Departures.new.records
  end

  def self.all
    [PLA::Arrivals.new.records,
     PLA::Departures.new.records].flatten.uniq
  end

  def self.method_missing(m, *args, &block)
    if  m.to_s =~ /^(.*)_by_(.*)_(.*)$/
      movement_type = $1
      field = $2
      field_key = $3

      if self.methods.include? movement_type.to_sym
        movements = self.send(movement_type.to_sym)

        movements.sort_by{|m| m[field.to_sym][field_key.to_sym]}
      else
        super
      end
    elsif m.to_s =~ /^(.*)_by_(.*)$/
      movement_type = $1
      field = $2

      if self.methods.include? movement_type.to_sym
        movements = self.send(movement_type.to_sym)
        movements.sort_by{|m| m[field.to_sym]}
      else
        super
      end
    else
      super
    end
  end

  def self.respond_to?(method_sym, include_private = false)
    if method_sym.to_s =~ /^(.*)_by_(.*)$/
      if self.methods.include? movement_type.to_sym
        true
      end
    else
      super
    end
  end
end
