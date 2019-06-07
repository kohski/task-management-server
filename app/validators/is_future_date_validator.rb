# frozen_string_literal: true

class IsFutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    return if record.base_date_time.nil?

    if record[:base_date_time] >= value
      record.errors[attribute] << (options[:message] || 'must be future date from base_date_time')
    end
  end
end
