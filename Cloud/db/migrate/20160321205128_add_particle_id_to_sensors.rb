class AddParticleIdToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :particle_id, :string
  end
end
