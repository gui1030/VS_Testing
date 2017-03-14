# == Schema Information
#
# Table name: hub_locations
#
#  id         :integer          not null, primary key
#  latitude   :string(255)
#  longitude  :string(255)
#  altitude   :integer
#  velocity   :float(24)
#  gps_time   :datetime
#  hub_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class HubLocation < ActiveRecord::Base
  belongs_to :hub
end
