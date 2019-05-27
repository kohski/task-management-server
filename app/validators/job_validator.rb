class JobValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    users = record.group.assigns.pluck(:user_id)
    unless users.index(record.owner_id)
      record.errors[attribute] << (options[:message]||" must be selected in group member")
    end
  end
end