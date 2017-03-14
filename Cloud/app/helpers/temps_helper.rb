module TempsHelper
  def temp_attr_title(attribute)
    case attribute.to_sym
    when :temp then 'Temperature'
    when :battery then 'Battery'
    when :humidity then 'Humidity'
    when :lux then 'Light'
    end
  end

  def temp_attr_label(attribute)
    case attribute.to_sym
    when :temp then "(#{temp_units})"
    when :battery then '(dV)'
    when :humidity then '(RH)'
    when :lux then '(lux)'
    end
  end

  def temp_units
    temp_units_for current_user
  end

  def temp_units_for(user)
    case user.default_units.to_sym
    when :metric then '°C'
    when :english then '°F'
    end
  end

  def convert_temp_for(user, temp)
    converter = ConversionService.new(user.default_units)
    number_with_precision(converter.convert(temp), precision: 1, strip_insignificant_zeros: true)
  end

  def convert_temp(temp)
    convert_temp_for current_user, temp
  end

  def scale_temp_for(user, temp)
    converter = ConversionService.new(user.default_units)
    number_with_precision(converter.scale(temp), precision: 1, strip_insignificant_zeros: true)
  end

  def scale_temp(temp)
    scale_temp_for current_user, temp
  end
end
