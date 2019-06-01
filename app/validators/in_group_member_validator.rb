class InGroupMemberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      return
    end


    if record.class.name == "Job"
      if record.group_id.nil?
        return
      end
      users = record.group.assigns.pluck(:user_id)

      unless users.index(record.owner_id)
        record.errors[attribute] << (options[:message]||"must be selected in group member")
      end
  
    end

    if record.class.name == "Step"
      if record.job.nil?
        return
      end
      users = record.job.group.assigns.pluck(:user_id)

      unless users.index(record.assigned_user)
        record.errors[attribute] << (options[:message]||"must be selected in group member")
      end  
    end
  end
end