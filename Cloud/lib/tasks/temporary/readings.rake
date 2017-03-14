namespace :readings do
  desc 'Set sensor_id based on cooler_id'
  task set_sensor: :environment do
    readings = SensorReading.where(sensor: nil)
    puts "Updating #{readings.count} readings"
    SensorReading.transaction do
      readings.joins(cooler_ref: :sensor)
              .group(:cooler_id)
              .update_all('sensor_readings.sensor_id = sensors.id')
    end
    puts 'Readings updated'
  end
end
