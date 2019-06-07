# frozen_string_literal: true

class InGroupMemberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    if record.class.name == 'Job'
      return if record.group_id.nil?
      users = record.group.assigns.pluck(:user_id)

      unless users.index(record.owner_id)
        record.errors[attribute] << (options[:message] || 'must be selected in group member')
      end

    end

    if record.class.name == 'Step'
      return if record.job.nil?
      users = record.job.group.assigns.pluck(:user_id)

      unless users.index(record.assigned_user)
        record.errors[attribute] << (options[:message] || 'must be selected in group member')
      end
    end
  end
end
