class RemoveExcessColumns < ActiveRecord::Migration
  def change
    remove_column :accounts, :stripe_id
    remove_columns :coolers,
      :active,
      :top_humid_threshold,
      :bottom_humid_threshold,
      :walk_in
    remove_columns :hubs,
      :auth_token,
      :iccid,
      :signal_quality,
      :cell_carrier
    remove_column :orders, :fulfilled
    remove_columns :sensor_readings,
      :user_id,
      :cooler_id,
      :tenant_id,
      :imported,
      :lux,
      :packet_loss,
      :signal_quality

    remove_columns :sensors,
      :signal_quality,
      :packet_loss

    remove_index :units, column: ["customer_id"]
    remove_index :units, column: ["district_id"]

    remove_columns :units,
      :wash_timer,
      :dispense_timer,
      :institution,
      :instance_type,
      :active,
      :vericlean,
      :veritemp,
      :veritrack,
      :temp_interval,
      :ranging_interval,
      :minutes_to_notify,
      :daily_report_time,
      :time_zone,
      :veritemp_packet_type,
      :last_daily_report_sent,
      :default_units,
      :district_id,
      :conn_attempts,
      :aws_topic,
      :last_notification_sent,
      :stripe_customer_id,
      :billing_enabled,
      :particle_token,
      :verigrow,
      :temp_active,
      :humid_active,
      :light_active,
      :battery_active,
      :customer_id,
      :subscription_id,
      :issues_count

    remove_index :users, [:customer_id]
    remove_index :users, [:district_id]
    remove_index :users, [:username]

    remove_columns :users,
      :username,
      :job_title,
      :role,
      :is_suspended,
      :default_app,
      :graph_type_default,
      :not_human,
      :imported,
      :last_threshold_sent,
      :battery_level,
      :tenant_admin,
      :district_id,
      :aws_sns_arn,
      :report_max_temp,
      :report_min_temp,
      :report_avg_temp,
      :report_compliance_temp,
      :report_comp_temp_range,
      :primary_contact,
      :device_name,
      :veritemp_packet_type,
      :billing_admin,
      :enable_wizard,
      :terms_accepted,
      :invitation_id,
      :customer_id,
      :invitation
  end
end
