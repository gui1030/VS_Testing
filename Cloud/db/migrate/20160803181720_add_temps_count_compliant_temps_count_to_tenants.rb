class AddTempsCountCompliantTempsCountToTenants < ActiveRecord::Migration

  def self.up

    add_column :tenants, :temps_count, :integer, :null => false, :default => 0

    add_column :tenants, :compliant_temps_count, :integer, :null => false, :default => 0

  end

  def self.down

    remove_column :tenants, :temps_count

    remove_column :tenants, :compliant_temps_count

  end

end
