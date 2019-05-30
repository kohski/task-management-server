class IsFutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      return
    end

    if record.base_date_time.nil? 
      return
    end

    if record[:base_date_time] >= value 
      record.errors[attribute] << (options[:message]||"must be future date from base_date_time")
    end
  end
end