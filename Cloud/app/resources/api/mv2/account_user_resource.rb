module Api
  module Mv2
    class AccountUserResource < UserResource
      has_one :account
    end
  end
end
