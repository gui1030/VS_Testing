
namespace :accounts do
  desc 'Create Accounts for Units without them'
  task create: :environment do
    units = Unit.where(account: nil)
    ActiveRecord::Base.transaction do
      t1 = Unit.find_by(name: 't1')
      t1.destroy if t1.present?
      units.each do |unit|
        account = Account.find_or_create_by!(name: unit.institution)
        unit.update!(account: account)
        print "Mapped #{unit} to #{account}"
      end
    end
  end
end
