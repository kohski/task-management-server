module AttributeCheck
  def attr_check(res_str,register_data)
    unmatch_num = 0
    register_dat.attributes.each do |key, value|
      if res_str[key] != value
        unmatch_num += 1
      end
    end
    unmatch_num == 0
  end
end