class AddAwsSnsArnToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :aws_sns_arn, :string
  end
end
