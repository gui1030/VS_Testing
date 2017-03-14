class AddAwsTopicToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :aws_topic, :string
  end
end
