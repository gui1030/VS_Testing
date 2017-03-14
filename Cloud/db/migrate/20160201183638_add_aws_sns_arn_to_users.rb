class AddAwsSnsArnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :aws_sns_arn, :string
  end
end
