module Validations

    def Validations.is_int? input
    if (Integer(input) rescue nil) != input.to_i
      return false
    else
      return true
    end
  end

  def Validations.is_float? input
    if (Float(input) rescue nil) != input.to_f
      return false
    else
      return true
    end
  end

end
