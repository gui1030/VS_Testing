# == Schema Information
#
# Table name: permissions
#
#  id              :integer          not null, primary key
#  account_user_id :integer
#  unit_id         :integer
#

class Permission < ActiveRecord::Base
  belongs_to :account_user
  belongs_to :unit
end
