# frozen_string_literal: true

module AttributeCheck
  def attr_check(res_str, _register_data)
    unmatch_num = 0
    register_dat.attributes.each do |key, value|
      unmatch_num += 1 if res_str[key] != value
    end
    unmatch_num == 0
  end
end
