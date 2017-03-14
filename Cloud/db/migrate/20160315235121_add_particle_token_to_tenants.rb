class AddParticleTokenToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :particle_token, :string
  end
end
