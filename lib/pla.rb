require 'pla/arrivals'
require 'pla/departures'
require 'pla/in_port'

class PLA
  def self.arrivals
    PLA::Arrivals.new.records
  end

  def self.departures
    PLA::Departures.new.records
  end

  def self.in_port
    PLA::InPort.new.records
  end

  def self.all
    [
      self.arrivals,
      self.departures,
      self.in_port
    ].flatten.uniq
  end

  def self.find movement_type, field, key
    if self.methods.include? movement_type
      movements = self.send(movement_type)

      if field == :location
        return [
          self.munge_by_field(movements, :select, :to, key),
          self.munge_by_field(movements, :select, :from, key)
        ].flatten.uniq
      else
        return self.munge_by_field movements, :select, field, key
      end
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
    if m.to_s =~ /^(find|sort)_(.*)_by_(.*)$/
      querier = $1
      type = $2.to_sym
      field = $3.to_sym

      if querier == 'find'
        return self.find(type, field, args.first)
      elsif querier == 'sort'
        return self.sort(type, field)
      end
    end
    super
  end

  def self.respond_to?(method_sym, include_private = false)
    if method_sym.to_s =~ /^(find|sort)_(.*)_by_(.*)$/ and
      self.methods.include? $2.to_sym
      true
    else
      super
    end
  end
end
