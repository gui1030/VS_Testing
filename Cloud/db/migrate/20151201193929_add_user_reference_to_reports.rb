class AddUserReferenceToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :user
  end
end