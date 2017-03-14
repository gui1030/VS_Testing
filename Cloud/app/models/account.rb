# == Schema Information
#
# Table name: accounts
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  confirmed_at      :datetime
#  terms_accepted    :boolean
#  deleted_at        :datetime
#  city              :string(255)
#  state             :string(255)
#  zipcode           :string(255)
#  address           :string(255)
#  address1          :string(255)
#

class Account < ActiveRecord::Base
  acts_as_paranoid

  has_many :units, dependent: :destroy, autosave: true
  has_many :users, class_name: 'AccountUser', dependent: :destroy, inverse_of: :account
  has_attached_file :logo, styles: { medium: '300x300>', thumb: '100x100>' }

  validates_attachment_content_type :logo, content_type: %r{\Aimage/.*\Z}
  validates :name, presence: true, allow_blank: false

  scope :search, -> (query) { where('name like ?', "%#{query}%") }

  def to_s
    name
  end

  def alerts?
    units.any? { |unit| unit.alerts.count > 0 }
  end

  def alerts_count
    units.map { |unit| unit.alerts.count }.inject(0, :+)
  end

  def confirmed?
    confirmed_at.present?
  end

  def confirm
    return if confirmed?
    self.confirmed_at = Time.current
    units.each(&:build_initial_order)
  end
end
