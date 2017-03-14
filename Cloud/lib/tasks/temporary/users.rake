
namespace :users do
  desc 'Set type of users'
  task set_type: :environment do
    users = User.where(type: nil)
    ActiveRecord::Base.transaction do
      users.each do |user|
        if (user.role == 'admin') || user.support_access
          user.update! type: 'Admin'
          print "#{user} -> Admin"
        elsif user.unit_id.present? && user.tenant_admin
          user.update! type: 'Account', account_id: Unit.find(user.unit_id).account_id
          print "#{user} -> AccountUser(#{user.account_id})"
        elsif user.unit_id.present? && !user.tenant_admin
          user.update! type: 'UnitUser'
          print "#{user} -> UnitUser(#{user.unit_id})"
        else
          print "#{user} -> ???"
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
