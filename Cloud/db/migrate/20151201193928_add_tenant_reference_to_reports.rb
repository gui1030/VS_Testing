class AddTenantReferenceToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :tenant
  end
end