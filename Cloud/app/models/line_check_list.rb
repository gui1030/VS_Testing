# == Schema Information
#
# Table name: line_check_lists
#
#  id           :integer          not null, primary key
#  unit_id      :integer
#  name         :string(255)
#  deleted_at   :datetime
#  items_count  :integer          default(0), not null
#  checks_count :integer          default(0), not null
#

class LineCheckList < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :unit
  has_many :line_check_items, dependent: :destroy
  has_many :line_checks, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :line_check_schedules, dependent: :destroy

  accepts_nested_attributes_for :line_check_items, :line_check_schedules, reject_if: :all_blank, allow_destroy: true

  validates :unit, presence: true
  validates :name, presence: true, allow_blank: false

  alias_attribute :items, :line_check_items
  alias_attribute :checks, :line_checks
  alias_attribute :schedules, :line_check_schedules
end
