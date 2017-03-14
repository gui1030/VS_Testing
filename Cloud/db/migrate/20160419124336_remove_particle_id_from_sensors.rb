class RemoveParticleIdFromSensors < ActiveRecord::Migration
  def change
  	remove_column :sensors, :particle_id
  end
end
