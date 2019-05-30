class IsDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    
    unless users.index(record.owner_id)
      record.errors[attribute] << (options[:message]||" must be selected in group member")
    end
  end
end