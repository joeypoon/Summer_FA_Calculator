module LoanCalculation

  private

  def set_annual_loan_limits
    if @dependency_status == "ind"
      case @grade_level
      when 1
        @annual_sub_limit = @ind1sub
        @annual_loan_limit = @ind1total
      when 2
        @annual_sub_limit = @ind2sub
        @annual_loan_limit = @ind2total
      when 3..5
        @annual_sub_limit = @ind3sub
        @annual_loan_limit = @ind3total
      when 6
        @annual_sub_limit = 0
        @annual_loan_limit = @grad_total
      end
    else
      case @grade_level
      when 1
        @annual_sub_limit = @dep1sub
        @annual_loan_limit = @dep1total
      when 2
        @annual_sub_limit = @dep2sub
        @annual_loan_limit = @dep2total
      else
        @annual_sub_limit = @dep3sub
        @annual_loan_limit = @dep3total
      end
    end
  end

  def calculate_sub
    if @fs_sub + @outside_sub < @annual_sub_limit
      if @fs_sub + @outside_sub + @fs_unsub + @outside_unsub < @annual_loan_limit
        @sub_award = @annual_sub_limit - (@fs_sub + @outside_sub)
        if @sub_award > @annual_sub_limit / 2
          @sub_award = @annual_sub_limit / 2
        end
        if @total_sub_borrowed + @sub_award >= @sub_agg
          @sub_award = @sub_agg - @total_sub_borrowed
        end

      else
        @sub_award = 0
      end

    else
      @sub_award = 0
    end

    if @sub_award < 0
      @sub_award = 0
    end
  end

  def calculate_unsub
    if @fs_unsub < @annual_loan_limit - (@fs_sub + @outside_sub)
      @unsub_award = @annual_loan_limit - (@sub_award + @fs_sub + @outside_sub + @fs_unsub + @outside_unsub)
      if @unsub_award > @annual_loan_limit/2
        @unsub_award = @annual_loan_limit/2 - @sub_award
      end
      if @total_loans_borrowed + @sub_award + @unsub_award >= @loan_agg
        @unsub_award = @loan_agg - (@total_loans_borrowed + @sub_award)
      end

      set_total_awards

      if @total_awards > @summer_budget
        @unsub_award -= (@total_awards - @summer_budget)
      end

    else
      @unsub_award = 0
    end

    if @unsub_award < 0
      @unsub_award = 0
    end
  end

  def set_total_loans_borrowed
    @total_loans_borrowed = @total_sub_borrowed + @total_unsub_borrowed
  end

end
