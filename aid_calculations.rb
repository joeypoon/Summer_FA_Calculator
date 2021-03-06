require_relative "validations"
require_relative "pell_calculation"
require_relative "loan_calculation"
require_relative "testing"

class AidCalculations

  include Validations
  include PellCalculation
  include LoanCalculation
  include Testing

  def ask_sap
    begin
      puts "\nPlease enter SAP status (good/bad): "
      @sap_status = gets.chomp
    end until @sap_status == "good" || @sap_status == "bad"
  end

  def is_sap
    if @sap_status == "bad"
      puts "***Please review Summer application after student's SAP is reviewed***"
      return true
    else
      return false
    end
  end

  def get_info
    ask_tasfa
    ask_dependency_status
    ask_old_budget
    ask_old_efc

    if @tasfa == "n"
      ask_pell_efc
      ask_fs_pell
      ask_fs_sub
      ask_fs_unsub
    end

    ask_fall_enrollment
    ask_spring_enrollment

    if @tasfa == "n"
      ask_leu
      ask_total_sub_borrowed
      ask_total_unsub_borrowed
      set_total_loans_borrowed
      check_leu
      check_loan_limits
    end

    check_enrollment
    ask_summer_budget
    #student.set_new_budget  #optional

    ask_new_efc
    check_efc
    set_summer_efc
    ask_grade_level
  end

  def calculate_awards
    max_mdtu = 1500
    if @tasfa == "n"
      calculate_pell
      calculate_mdtus
      set_annual_loan_limits
      calculate_sub
      calculate_unsub
      set_total_awards
      check_over_summer_budget
    else
      @mdtut = max_mdtu
    end
  end

  def display_awards
    if @tasfa == "n"
      puts "\nPell: " + @pell_award.to_s
      puts "MDTUS: " + @mdtus.to_s
      puts "Sub Loans: " + @sub_award.to_s
      puts "Unsub Loans: " + @unsub_award.to_s
    else
      puts "MDTUT: " + @mdtut.to_s
    end
  end

  def display_roausdf
    puts "\n***Please input in ROAUSDF: LEU, Summer hours, budget, and EFC***"
    puts "\nLEU: " + @pell_leu.to_s + " \nSummer budget: " + @summer_budget.to_s + " \nSummer EFC: " + @summer_efc.to_s
  end

  def display_stats
    puts "\nFill out sum app form: "
    puts "SAP: " + @sap_status.to_s + "\nFall + Spring Pell: " + @fs_pell.to_s + "\nNew Budget: " + @new_budget.to_s + "\nOld Budget: " + @old_budget.to_s + "\nSummer Budget: " + @summer_budget.to_s + "\nNew EFC: " + @new_efc.to_s + "\nOld EFC: " + @old_efc.to_s + "\nSummer EFC: " + @summer_efc.to_s + "\nSummer Pell: " + @pell_award.to_s + "\nSummer Sub: " + @sub_award.to_s + "\nSummer Unsub: " + @unsub_award.to_s + "\nMDTUS: " + @mdtus.to_s + "\nMDTUT: " + @mdtut.to_s
  end

  private

  def initialize
    #2014-2015 Annual Limits
    @dep1sub = 3500
    @dep1total = 5500
    @dep2sub = 4500
    @dep2total = 6500
    @dep3sub = 5500
    @dep3total = 7500
    @ind1sub = 3500
    @ind1total = 9500
    @ind2sub = 4500
    @ind2total = 10500
    @ind3sub = 5500
    @ind3total = 12500
    @grad_total = 20500
    @annual_pell = 5730

    #2014-2015 Aggregate Limits
    @sub_agg = 23000
    @loan_agg = 57500
    @grad_agg = 138500

    #Default values
    @fs_pell = 0
    @pell_award = 0
    @sub_award = 0
    @unsub_award = 0
    @mdtus = 0
    @mdtut = 0
    @outside_pell = 0
    @outside_sub = 0
    @outside_unsub = 0
    @tasfa = "n"
  end

  def ask_tasfa
    begin
      puts "\nIs student TASFA? (y/n): "
      @tasfa = gets.chomp
    end until @tasfa == "y" || @tasfa == "n"
  end

  def ask_dependency_status
    begin
      puts "\nPlease enter dependency status (dep/ind): "
      @dependency_status = gets.chomp
    end until @dependency_status == "ind" || @dependency_status == "dep"
  end

  def ask_old_budget
    begin
      puts "\nPlease enter old budget: "
      @old_budget = gets.chomp
    end until is_int? @old_budget
      @old_budget = @old_budget.to_i
  end

  def ask_old_efc
    begin
      puts "\nPlease enter old EFC: "
      @old_efc = gets.chomp
    end until is_int? @old_efc
    @old_efc = @old_efc.to_i
  end

  def ask_pell_efc
    begin
      puts "\nPlease enter Pell EFC: "
      @pell_efc = gets.chomp
    end until is_int? @pell_efc
    @pell_efc = @pell_efc.to_i
  end

  def is_sap?
    if @sap_status == "bad"
      return true
    else
      return false
    end
  end

  def ask_fs_pell
    begin
      puts "\nPlease enter Fall + Spring Pell: "
      @fs_pell = gets.chomp
    end until is_int? @fs_pell
    @fs_pell = @fs_pell.to_i
  end

  def ask_fs_sub
    begin
      puts "\nPlease enter Fall + Spring Sub: "
      @fs_sub = gets.chomp
    end until is_int? @fs_sub
    @fs_sub = @fs_sub.to_i
  end

  def ask_fs_unsub
    begin
      puts "\nPlease enter Fall + Spring Unsub: "
      @fs_unsub = gets.chomp
    end until is_int? @fs_unsub
    @fs_unsub = @fs_unsub.to_i
  end

  def ask_fall_enrollment
    begin
      puts "\nPlease enter Fall enrollment: "
      @fall_enrollment = gets.chomp
    end until is_int? @fall_enrollment
    @fall_enrollment = @fall_enrollment.to_i
  end

  def ask_spring_enrollment
    begin
      puts "\nPlease enter Spring enrollment: "
      @spring_enrollment = gets.chomp
    end until is_int? @spring_enrollment
    @spring_enrollment = @spring_enrollment.to_i
  end

  def ask_leu
    begin
      puts "\nPlease enter LEU: "
      @pell_leu = gets.chomp
    end until is_float? @pell_leu
    @pell_leu = @pell_leu.to_f
  end

  def ask_total_sub_borrowed
    begin
      puts "\nPlease enter total Sub borrowed: "
      @total_sub_borrowed = gets.chomp
    end until is_int? @total_sub_borrowed
    @total_sub_borrowed = @total_sub_borrowed.to_i
  end

  def ask_total_unsub_borrowed
    begin
      puts "\nPlease enter total Unsub borrowed: "
      @total_unsub_borrowed = gets.chomp
    end until is_int? @total_unsub_borrowed
    @total_unsub_borrowed = @total_unsub_borrowed.to_i
  end

  def ask_outside_pell
    begin
      puts "\nEnter amount of outside Pell: "
      @outside_pell = gets.chomp
    end until is_int? @outside_pell
    @outside_pell = @outside_pell.to_i
  end

  def ask_outside_sub
    begin
      puts "\nEnter amount of outside sub: "
      @outside_sub = gets.chomp
    end until is_int? @outside_sub
    @outside_sub = @outside_sub.to_i
  end

  def ask_outside_unsub
    begin
      puts "\nEnter amount of outside unsub: "
      @outside_unsub = gets.chomp
    end until is_int? @outside_unsub
    @outside_unsub = @outside_unsub.to_i
  end

  def check_enrollment
    if @fall_enrollment == 0 || @spring_enrollment == 0
      puts "\n***Please check NSLDS and add student to TM***"
      ask_outside_pell
      ask_outside_sub
      ask_outside_unsub
    end
  end

  def check_leu
    if @pell_leu >= 500
      puts "\n***Please confirm Pell LEU on NSLDS***"
      ask_leu
    end
  end

  def check_loan_limits
    if @total_loans_borrowed > @loan_agg || @total_sub_borrowed > @sub_agg
      puts "\n***Loan limits exceeded***"
      gets
    end
  end

  def ask_summer_budget
    begin
      puts "\nPlease enter Summer budget: "
      @summer_budget = gets.chomp
    end until is_int? @summer_budget
    @summer_budget = @summer_budget.to_i
    set_new_budget
  end

  def set_new_budget
    @new_budget = @old_budget + @summer_budget
  end

  def ask_new_efc
    begin
      puts "\nPlease enter new EFC: "
      @new_efc = gets.chomp
    end until is_int? @new_efc
    @new_efc = @new_efc.to_i
  end

  def check_efc
    while @new_efc < @old_efc
      puts "\nNew EFC must be larger than or equal to old EFC."
      ask_old_efc
      ask_new_efc
    end
  end

  def set_summer_efc
    @summer_efc = @new_efc - @old_efc
  end

  def ask_grade_level
    begin
      puts "\nPlease enter student grade level (1, 2, 3, 4, 5, or 6): "
      @grade_level = gets.chomp.to_i
    end until @grade_level >= 1 && @grade_level <= 6
  end

  def calculate_mdtus
    award_threshold = 1000
    max_mdtu = 1500
    if @pell_award < award_threshold && @grade_level != 6
      @mdtus = max_mdtu - @pell_award
    else
      @mdtus = 0
    end
  end

  def set_total_awards
    @total_awards = @pell_award + @sub_award + @unsub_award + @mdtus + @mdtut
  end

  def set_need_awards
    @need_awards = @sub_award + @pell_award + @mdtus + @mdtut
  end

  def check_unmet_need
    @gross_need = @new_budget - @new_efc
    set_need_awards
    if @need_awards > @gross_need
      if @sub_award > 0
        @sub_award = @sub_award - (@need_awards - @gross_need)
        if @sub_award < 0
          @sub_award = 0
        end
        calculate_unsub
        set_need_awards
      end
    end
    if @need_awards > @gross_need
      if @pell_award > 0
        @pell_award = @pell_award - (@need_awards - @gross_need)
        if @pell_award < 0
          @pell_award = 0
        end
        calculate_unsub
        set_need_awards
      end
    end
    if @need_awards > @gross_need
      if @mdtus > 0
        @mdtus = @mdtus - (@need_awards - @gross_need)
        if @mdtus < 0
          @mdtus = 0
        end
        calculate_unsub
        set_need_awards
      end
    end
    if @need_awards > @gross_need
      if @mdtut > 0
        @mdtut = @mdtut - (@need_awards - @gross_need)
        if @mdtut < 0
          @mdtut = 0
        end
        calculate_unsub
        set_need_awards
      end
    end
  end

  def check_unsub_over_budget
    if @total_awards > @summer_budget - @summer_efc
      if @unsub_award > 0
        @unsub_award -= (@total_awards - (@summer_budget - @summer_efc))
        if @unsub_award < 0
          @unsub_award = 0
        end
      end
      set_total_awards
    end
  end

  def check_sub_over_budget
    if @total_awards > @summer_budget - @summer_efc
      if @sub_award > 0
        @sub_award -= (@total_awards - (@summer_budget - @summer_efc))
        if @sub_award < 0
          @sub_award = 0
        end
      end
      set_total_awards
    end
  end

  def check_mdtus_over_budget
    if @total_awards > @summer_budget - @summer_efc
      if @mdtus > 0
        @mdtus -= (@total_awards - (@summer_budget - @summer_efc))
        if @mdtus < 0
          @mdtus = 0
        end
      end
      set_total_awards
    end
  end

  def check_pell_over_budget
    if @total_awards > @summer_budget - @summer_efc
      if @pell_award > 0
        @pell_award -= (@total_awards - (@summer_budget - @summer_efc))
        if @pell_award < 0
          @pell_award = 0
        end
      end
      set_total_awards
    end
  end

  def check_over_summer_budget
    check_unsub_over_budget
    check_sub_over_budget
    check_mdtus_over_budget
    check_pell_over_budget
    check_unmet_need
  end

end
