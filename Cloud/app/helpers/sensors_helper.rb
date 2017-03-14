module SensorsHelper
  def offline_class(sensor)
    sensor.offline? ? 'offline' : ''
  end

  def sensor_battery_icon(sensor)
    battery = sensor.battery
    stage = sensor_battery_stage(battery) || 1
    content_tag :i, nil, class: "vs vs-battery-#{stage} text-primary", data: {
      toggle: 'tooltip',
      title: battery ? "#{battery} dV" : 'n/a'
    }
  end

  def sensor_battery_stage(d_v)
    case d_v
    when 0...27 then 1
    when 27...28 then 2
    when 28...29 then 3
    when 29...30 then 4
    when 30..Float::INFINITY then 5
    end
  end
end
