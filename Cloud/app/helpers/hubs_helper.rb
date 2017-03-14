module HubsHelper
  def hub_battery_icon(hub)
    battery = hub.battery
    stage = hub_battery_stage(battery) || 1
    content_tag :i, nil, class: "vs vs-battery-#{stage} text-primary", data: {
      toggle: 'tooltip',
      title: battery ? "#{battery}%" : 'n/a'
    }
  end

  def hub_battery_stage(battery)
    case battery
    when 0...20 then 1
    when 20...40 then 2
    when 40...60 then 3
    when 60...80 then 4
    when 80..100 then 5
    end
  end

  def hub_rssi_icon(hub)
    rssi = hub.rssi
    bars = hub_rssi_bars(rssi) || 1
    content_tag :i, nil, class: "vs vs-bars-#{bars} text-primary", data: {
      toggle: 'tooltip',
      title: "RSSI: #{rssi || 'n/a'}"
    }
  end

  def hub_rssi_bars(rssi)
    case rssi
    when -Float::INFINITY...-110 then 1
    when -110...-100 then 2
    when -100...-90 then 3
    when -90...-80 then 4
    when -80...Float::INFINITY then 5
    end
  end
end
