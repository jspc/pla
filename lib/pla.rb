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

  def self.find movement_type, field, key
    if self.methods.include? movement_type
      movements = self.send(movement_type)

      if field =~ /^(.*)_(.*)$/
        field = $1
        field_key = $2

        m = movements.select{|m| m[field.to_sym][field_key.to_sym] == key}
      else
        m = movements.select{|m| m[field.to_sym] == key}
      end
      m
    else
      []
    end
  end

  def self.method_missing(m, *args, &block)
    if m.to_s =~ /^find_(.*)_by_(.*)$/
      movement_type = $1
      field = $2

      return self.find(movement_type.to_sym, field.to_sym, args.first)

    elsif m.to_s =~ /^(.*)_by_(.*)$/
      movement_type = $1
      field = $2

      if self.methods.include? movement_type.to_sym
        movements = self.send(movement_type.to_sym)

        if field =~ /^(.*)_(.*)$/
          field = $1
          field_key = $2

          m = movements.sort_by{|m| m[field.to_sym][field_key.to_sym]}
        else
          m = movements.sort_by{|m| m[field.to_sym]}
        end
        return m
      end
    end
    super
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
