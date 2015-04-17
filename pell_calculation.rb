module PellCalculation

  private

  def calculate_pell
    no_pell_threshold = 5157  #EFC threshold for no Pell
    lowest_pell_threshold = 5101  #Bottom EFC for lowest Pell award bracket
    lowest_pell = 602  #Lowest Pell for 1415 AY
    lower_pell_bound = 100  #Lower bound of EFC bracket for regular Pell calc
    upper_pell_bound = 5100  #Upper bound of EFC bracket for regular Pell calc
    if @fall_enrollment + @spring_enrollment >= 24 || @grade_level > 4
      @pell_award = 0
    else
      if @pell_efc > no_pell_threshold
        @annual_pell = 0
      elsif @pell_efc >= lowest_pell_threshold && @pell_efc <= no_pell_threshold
        @annual_pell = lowest_pell
      elsif @pell_efc > lower_pell_bound && @pell_efc <= upper_pell_bound
        pell_factor = (@pell_efc - 1) / 100
        @annual_pell = @annual_pell - (50 + pell_factor * 100)
      elsif @pell_efc > 0 && @pell_efc <= lower_pell_bound
        @annual_pell = @annual_pell - 50
      end

      if @pell_leu > 575  #Check if less than a quarter of annual pell remaining
        @pell_award = ((600 - @pell_leu) * 0.01) * @annual_pell
        if @pell_award > @annual_pell - (@fs_pell + @outside_pell)
          @pell_award = @annual_pell - (@fs_pell + @outside_pell)
        end
      else
        @pell_award = @annual_pell - (@fs_pell + @outside_pell)
      end
      if @pell_award > @annual_pell / 4
        @pell_award = @annual_pell / 4
      end
    end
    if @pell_award < 0
      @pell_award = 0
    end
    @pell_award = @pell_award.to_i
  end

end
