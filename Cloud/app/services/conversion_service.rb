class ConversionService
  attr_accessor :units

  def initialize(units)
    @units = units
  end

  def convert(temp)
    temp && case units
            when 'metric' then temp
            when 'english' then (temp * 1.8 + 32)
            end
  end

  def deconvert(temp)
    temp && case units
            when 'metric' then temp
            when 'english' then ((temp - 32) / 1.8)
            end
  end

  def scale(temp)
    temp && case units
            when 'metric' then temp
            when 'english' then (temp * 1.8)
            end
  end

  def descale(temp)
    temp && case units
            when 'metric' then temp
            when 'english' then (temp / 1.8)
            end
  end
end
