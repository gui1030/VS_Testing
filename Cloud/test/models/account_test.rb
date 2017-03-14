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

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
