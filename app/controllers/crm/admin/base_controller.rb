module Crm
  class Admin::BaseController < AdminController

    def member_params
      if current_member
        { member_id: current_member.all_follower_ids }
      else
        {}
      end
    end

    def transfer_params(original_params = {})
      r = {}
      if original_params['age-gte']
        r['birthday-gte'] = ''
      end
    end

  end
end
