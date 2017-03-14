class AddAwsTopicToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :aws_topic, :string
  end
end
