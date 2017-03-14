class CoolerPolicy < RestrictedPolicy
  def sensor_data?
    default_read
  end

  def permitted_attributes
    attributes = [:active_notifications,
                  :name,
                  :top_temp_threshold,
                  :bottom_temp_threshold,
                  :top_humidity_threshold,
                  :bottom_humidity_threshold,
                  :description,
                  :humidity_notifications]
    attributes << { sensor_attributes: [:mac] } if user.is_a? Admin
    attributes
  end
end
