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
      return self.munge_by_field movements, :select, field, key
    end
    []
  end

  def self.sort movement_type, field
    if self.methods.include? movement_type
      movements = self.send(movement_type)
      return self.munge_by_field movements, :sort_by, field
    end
    []
  end

  def self.munge_by_field movements, method, field, search_value=nil
    if field =~ /^(.*)_(.*)$/
      field = $1
      field_key = $2

      search_value.nil? ?
        movements.send(method){|m| m[field.to_sym][field_key.to_sym]} :
        movements.send(method){|m| m[field.to_sym][field_key.to_sym] == search_value}

    else
      search_value.nil? ?
        movements.send(method){|m| m[field.to_sym]} :
        movements.send(method){|m| m[field.to_sym] == search_value}
    end
  end

  def self.method_missing(m, *args, &block)
    if m.to_s =~ /^(.*)_by_(.*)$/
      movement_type = $1.to_sym
      field = $2.to_sym

      if movement_type.to_s =~ /^find_(.*)$/
        movement_type = $1.to_sym
        return self.find(movement_type, field, args.first)
      else
        return self.sort(movement_type, field)
      end
    end
    super
  end

  def self.respond_to?(method_sym, include_private = false)
    if method_sym.to_s =~ /^(.*)_by_(.*)$/
      true
    else
      super
    end
  end
end
