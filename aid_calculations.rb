class AidCalculations

  def test
    test_tasfa
    test_dependency_status
    test_grade_level
    test_old_budget
    test_old_efc
    test_pell_efc
    test_sap_status
    test_fs_pell
    test_fs_sub
    test_fs_unsub
    test_fall_enrollment
    test_spring_enrollment
    test_pell_leu
    test_total_sub_borrowed
    test_total_unsub_borrowed
    set_total_loans_borrowed
    test_summer_budget
    set_new_budget
    test_new_efc
    set_summer_efc

    calculate_awards
    display_awards
    display_stats
  end

  def ask_sap
    begin
      puts "\nPlease enter SAP status (good/bad): "
      @sap_status = gets.chomp
    end until @sap_status == "good" || @sap_status == "bad"
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
    @dep3total = 5500
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


  def is_int? input
    if (Integer(input) rescue nil) != input.to_i
      return false
    else
      return true
    end
  end

  def is_float? input
    if (Float(input) rescue nil) != input.to_f
      return false
    else
      return true
    end
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

  def set_total_loans_borrowed
    @total_loans_borrowed = @total_sub_borrowed + @total_unsub_borrowed
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
      else
        @pell_award = @annual_pell - (@fs_pell + @outside_pell)
        if @pell_award > @annual_pell / 4
          @pell_award = @annual_pell / 4
        end
      end
    end
    if @pell_award < 0
      @pell_award = 0
    end
  end

  def calculate_mdtus
    award_threshold = 1000
    max_mdtu = 1500
    if @pell_award < award_threshold
      @mdtus = max_mdtu - @pell_award
    else
      @mdtus = 0
    end
  end

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
        @annual_loan_limit = @dep3total
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
    if @fs_sub > 0 && @fs_sub + @outside_sub < @annual_sub_limit
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

  def set_total_awards
    @total_awards = @pell_award + @sub_award + @unsub_award + @mdtus + @mdtut
  end

  def calculate_unsub
    if @fs_unsub > 0 && @fs_unsub < @annual_loan_limit - (@fs_sub + @outside_sub)
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
  end

  def test_tasfa
    random = rand(5) #tasfa students are less common
    if random == 0
      @tasfa = "y"
    else
      @tasfa = "n"
    end
  end

  def test_dependency_status
    random = rand(2)
    if random == 0
      @dependency_status = "dep"
    else
      @dependency_status = "ind"
    end
  end

  def test_old_budget
    random = rand(3)
    @one_semester = 10993
    @two_semesters = 22000
    if random == 0
      @old_budget = 0
    elsif random == 1
      @old_budget = @one_semester
    else
      @old_budget = @two_semesters
    end
  end

  def test_old_efc
    @max_efc = 6000 #max is 999999 but most are 0 and generally do not exceed 20000 in which case there is little practical difference
    @half_efc = @max_efc * 0.6 #not really half because costs are not perfectly halved
    if @old_budget == 0
      @old_efc = 0
    elsif @old_budget == @one_semester
      @old_efc = rand(@half_efc)
    else
      @old_efc = rand(@max_efc)
    end
  end

  def test_pell_efc
    @pell_efc = rand(@max_efc)
  end

  def test_sap_status
    if rand(10) == 0 #sap don't qualify so not as useful to test many
      @sap_status = "bad"
    else
      @sap_status = "good"
    end
  end

  def test_fs_pell
    @fs_pell = rand(@annual_pell) + 1
  end

  def test_fs_sub
    set_annual_loan_limits
    @fs_sub = rand(@annual_sub_limit) + 1
  end

  def test_fs_unsub
    @fs_unsub = rand(@annual_loan_limit - @fs_sub) + 1
  end

  def test_fall_enrollment
    @fall_enrollment = rand(16)
  end

  def test_spring_enrollment
    @spring_enrollment = rand(16)
  end

  def test_pell_leu
    @pell_leu = rand(601)
  end

  def test_total_sub_borrowed
    @total_sub_borrowed = rand(@sub_agg)
  end

  def test_total_unsub_borrowed
    @total_unsub_borrowed = rand(@loan_agg - @total_sub_borrowed)
  end

  def test_summer_budget
    off_campus = 6947
    with_parents = 5525
    if rand(2) == 0
      @summer_budget = with_parents
    else
      @summer_budget = off_campus
    end
  end

  def test_new_efc
    if rand(2) == 0
      @new_efc = @old_efc
    else
      @new_efc = @old_efc + @old_efc * 0.01
    end
  end

  def test_grade_level
    @grade_level = rand(6) + 1
  end

end
