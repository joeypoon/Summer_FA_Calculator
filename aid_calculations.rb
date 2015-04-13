class AidCalculations

  attr_accessor :tasfa
  attr_accessor :dependency_status
  attr_accessor :old_budgets
  attr_accessor :old_efc
  attr_accessor :pell_efc
  attr_accessor :sap_status
  attr_accessor :fs_pell
  attr_accessor :fs_sub
  attr_accessor :fs_unsub
  attr_accessor :fall_enrollment
  attr_accessor :spring_enrollment
  attr_accessor :pell_leu
  attr_accessor :total_sub_borrowed
  attr_accessor :total_unsub_borrowed
  attr_accessor :summer_budget
  attr_accessor :new_efc
  attr_accessor :new_budget
  attr_accessor :summer_efc
  attr_accessor :grade_level
  attr_accessor :annual_pell
  attr_accessor :annual_sub_limit
  attr_accessor :annual_loan_limit

  attr_accessor :sub_agg
  attr_accessor :loan_agg
  attr_accessor :grad_agg

  attr_accessor :no_pell_threshold
  attr_accessor :lowest_pell_threshold
  attr_accessor :lowest_pell
  attr_accessor :lower_pell_bound
  attr_accessor :upper_pell_bound

  attr_accessor :pell_award
  attr_accessor :sub_award
  attr_accessor :unsub_award
  attr_accessor :mdtus
  attr_accessor :mdtut
  attr_accessor :outside_pell
  attr_accessor :outside_sub
  attr_accessor :outside_unsub
  attr_accessor :total_awards

  attr_accessor :dep1_sub
  attr_accessor :dep3total
  attr_accessor :dep2_sub
  attr_accessor :dep2total
  attr_accessor :dep3_sub
  attr_accessor :dep3total
  attr_accessor :ind1sub
  attr_accessor :ind1total
  attr_accessor :ind2sub
  attr_accessor :ind2total
  attr_accessor :ind3sub
  attr_accessor :ind3total
  attr_accessor :grad_total

  DEP1_SUB = 3500

  def initialize
    #2014-2015 Annual Limits
    @dep1_sub = 3500
    dep1_total = 5500
    dep2_sub = 4500
    dep2_total = 6500
    dep3_sub = 5500
    dep3_total = 7500
    ind1_sub = 3500
    ind1_total = 9500
    ind2_sub = 4500
    ind2_total = 10500
    ind3_sub = 5500
    ind3_total = 12500
    grad_total = 20500
    annual_pell = 5730

    #2014-2015 Aggregate Limits
    sub_agg = 23000
    loan_agg = 57500
    grad_agg = 138500

    #Default values
    fs_pell = 0
    pell_award = 0
    sub_award = 0
    unsub_award = 0
    mdtus = 0
    mdtut = 0
    outside_pell = 0
    outside_sub = 0
    outside_unsub = 0
    tasfa = "n"
    total_sub_borrowed = 0
    total_unsub_borrowed = 0

    no_pell_threshold = 5157  #EFC threshold for no Pell
    lowest_pell_threshold = 5101  #Bottom EFC for lowest Pell award bracket
    lowest_pell = 602  #Lowest Pell for 1415 AY
    lower_pell_bound = 100  #Lower bound of EFC bracket for regular Pell calc
    upper_pell_bound = 5100  #Upper bound of EFC bracket for regular Pell calc
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
      tasfa = gets.chomp
    end until tasfa == "y" || tasfa == "n"
  end

  def is_tasfa?
    if tasfa == "y"
      return true
    else
      return false
    end
  end

  def ask_dependency_status
    begin
      puts "\nPlease enter dependency status (dep/ind): "
      dependency_status = gets.chomp
    end until dependency_status == "ind" || dependency_status == "dep"
  end

  def ask_old_budget
    begin
      puts "\nPlease enter old budget: "
      old_budget = gets.chomp
    end until is_int? old_budget
      old_budget = old_budget.to_i
  end

  def ask_old_efc
    begin
      puts "\nPlease enter old EFC: "
      old_efc = gets.chomp
    end until is_int? old_efc
    old_efc = old_efc.to_i
  end

  def ask_pell_efc
    begin
      puts "\nPlease enter Pell EFC: "
      pell_efc = gets.chomp
    end until is_int? pell_efc
    pell_efc = pell_efc.to_i
  end

  def ask_sap
    begin
      puts "\nPlease enter SAP status (good/bad): "
      sap_status = gets.chomp
    end until sap_status == "good" || sap_status == "bad"
  end

  def is_sap?
    if sap_status == "bad"
      return true
    else
      return false
    end
  end

  def ask_fs_pell
    begin
      puts "\nPlease enter Fall + Spring Pell: "
      fs_pell = gets.chomp
    end until is_int? fs_pell
    fs_pell = fs_pell.to_i
  end

  def ask_fs_sub
    begin
      puts "\nPlease enter Fall + Spring Sub: "
      fs_sub = gets.chomp
    end until is_int? fs_sub
    fs_sub = fs_sub.to_i
  end

  def ask_fs_unsub
    begin
      puts "\nPlease enter Fall + Spring Unsub: "
      fs_unsub = gets.chomp
    end until is_int? fs_unsub
    fs_unsub = fs_unsub.to_i
  end

  def ask_fall_enrollment
    begin
      puts "\nPlease enter Fall enrollment: "
      fall_enrollment = gets.chomp
    end until is_int? fall_enrollment
    fall_enrollment = fall_enrollment.to_i
  end

  def ask_spring_enrollment
    begin
      puts "\nPlease enter Spring enrollment: "
      spring_enrollment = gets.chomp
    end until is_int? spring_enrollment
    spring_enrollment = spring_enrollment.to_i
  end

  def ask_leu
    begin
      puts "\nPlease enter LEU: "
      pell_leu = gets.chomp
    end until is_float? pell_leu
    pell_leu = pell_leu.to_f
  end

  def ask_total_sub_borrowed
    begin
      puts "\nPlease enter total Sub borrowed: "
      total_sub_borrowed = gets.chomp
    end until is_int? total_sub_borrowed
    total_sub_borrowed = total_sub_borrowed.to_i
  end

  def ask_total_unsub_borrowed
    begin
      puts "\nPlease enter total Unsub borrowed: "
      total_unsub_borrowed = gets.chomp
    end until is_int? total_unsub_borrowed
    total_unsub_borrowed = total_unsub_borrowed.to_i
  end

  def ask_outside_pell
    begin
      puts "\nEnter amount of outside Pell: "
      outside_pell = gets.chomp
    end until is_int? outside_pell
    outside_pell = outside_pell.to_i
  end

  def ask_outside_sub
    begin
      puts "\nEnter amount of outside sub: "
      outside_sub = gets.chomp
    end until is_int? outside_sub
    outside_sub = outside_sub.to_i
  end

  def ask_outside_unsub
    begin
      puts "\nEnter amount of outside unsub: "
      outside_unsub = gets.chomp
    end until is_int? outside_unsub
    outside_unsub = outside_unsub.to_i
  end

  def check_enrollment
    if fall_enrollment == 0 || spring_enrollment == 0
      puts "\n***Please check NSLDS and add student to TM***"
      ask_outside_pell
      ask_outside_sub
      ask_outside_unsub
    end
  end

  def check_leu
    if pell_leu >= 500
      puts "\n***Please confirm Pell LEU on NSLDS***"
      ask_leu
    end
  end

  def check_loan_limits
    if total_sub_borrowed + total_unsub_borrowed > loan_agg || total_sub_borrowed > sub_agg
      puts "\n***Loan limits exceeded***"
      gets
    end
  end

  def ask_summer_budget
    begin
      puts "\nPlease enter Summer budget: "
      summer_budget = gets.chomp
    end until is_int? summer_budget
    summer_budget = summer_budget.to_i
  end

  def set_new_budget
    new_budget = old_budget + summer_budget
  end

  def ask_new_efc
    begin
      puts "\nPlease enter new EFC: "
      new_efc = gets.chomp
    end until is_int? new_efc
    new_efc = new_efc.to_i
  end

  def check_efc
    while new_efc < old_efc
      puts "\nNew EFC must be larger than or equal to old EFC."
      ask_old_efc
      ask_new_efc
    end
    summer_efc = new_efc - old_efc
  end

  def ask_grade_level
    begin
      puts "\nPlease enter student grade level (1, 2, 3, 4, 5, or 6): "
      grade_level = gets.chomp.to_i
    end until grade_level >= 1 && grade_level <= 6
  end

  def calculate_awards
    max_mdtu = 1500
    if !is_tasfa?
      calculate_pell
      calculate_mdtus
      set_annual_loan_limits
      calculate_sub
      calculate_unsub
      set_total_awards
      check_over_summer_budget
    else
      mdtut = max_mdtu
    end
  end

  def display_awards
    if tasfa == "n"
      puts "\nPell: " + pell_award.to_s
      puts "MDTUS: " + mdtus.to_s
    else
      puts "MDTUT: " + mdtut.to_s
    end
    puts "Sub Loans: " + sub_award.to_s
    puts "Unsub Loans: " + unsub_award.to_s
  end

  def display_stats
    puts "\nFill out sum app form: "
    puts "SAP: " + sap_status.to_s + "\nFall + Spring Pell: " + fs_pell.to_s + "\nNew Budget: " + new_budget.to_s + "\nOld Budget: " + old_budget.to_s + "\nSummer Budget: " + summer_budget.to_s + "\nNew EFC: " + new_efc.to_s + "\nOld EFC: " + old_efc.to_s + "\nSummer EFC: " + summer_efc.to_s + "\nSummer Pell: " + pell_award.to_s + "\nSummer Sub: " + sub_award.to_s + "\nSummer Unsub: " + unsub_award.to_s + "\nMDTUS: " + mdtus.to_s + "\nMDTUT: " + mdtut.to_s
  end

  #private

  def calculate_pell
    if fall_enrollment + spring_enrollment >= 24 || grade_level > 4
      pell_award = 0
    else
      if pell_efc > no_pell_threshold
        annual_pell = 0
      elsif pell_efc >= lowest_pell_threshold && pell_efc <= no_pell_threshold
        annual_pell = lowest_pell
      elsif pell_efc > lower_pell_bound && pell_efc <= upper_pell_bound
        pell_factor = (pell_efc - 1) / 100
        annual_pell = annual_pell - (50 + pell_factor * 100)
      elsif pell_efc > 0 && pell_efc <= lower_pell_bound
        annual_pell = annual_pell - 50
      end

      if pell_leu > 575  #Check if less than a quarter of annual pell remaining
        pell_award = ((600 - pell_leu) * 0.01) * annual_pell
      else
        pell_award = annual_pell - (fs_pell + outside_pell)
        if pell_award > annual_pell / 4
          pell_award = annual_pell / 4
        end
      end
    end
  end

  def calculate_mdtus
    award_threshold = 1000
    max_mdtu = 1500
    if pell_award < award_threshold
      mdtus = max_mdtu - pell_award
    else
      mdtus = 0
    end
  end

  def set_annual_loan_limits
    if dependency_status == "ind"
      case grade_level
      when 1
        annual_sub_limit = ind1_sub
        annual_loan_limit = ind1_total
      when 2
        annual_sub_limit = ind2_sub
        annual_loan_limit = ind2_total
      when 3..5
        annual_sub_limit = ind3_sub
        annual_loan_limit = ind3_total
      when 6
        annual_sub_limit = 0
        annual_loan_limit = grad_total
      end
    else
      case grade_level
      when 1
        annual_sub_limit = dep1_sub
        annual_loan_limit = dep3_total
      when 2
        annual_sub_limit = dep2_sub
        annual_loan_limit = dep2_total
      else
        annual_sub_limit = dep3_sub
        annual_loan_limit = dep3_total
      end
    end
  end

  def calculate_sub
    if fs_sub > 0 && fs_sub + outside_sub < annual_sub_limit
      if fs_sub + outside_sub + fs_unsub + outside_unsub < annual_loan_limit
        sub_award = annual_sub_limit - (fs_sub + outside_sub)
        if sub_award > annual_sub_limit / 2
          sub_award = annual_sub_limit / 2
        end
        if total_sub_borrowed + sub_award >= sub_agg
          sub_award = sub_agg - total_sub_borrowed
        end

      else
        sub_award = 0
      end

    else
      sub_award = 0
    end
  end

  def set_total_awards
    total_awards = pell_award + sub_award + unsub_award + mdtus + mdtut
  end

  def calculate_unsub
    if fs_unsub > 0 && fs_unsub < annual_loan_limit - (fs_sub + outside_sub)
      unsub_award = annual_loan_limit - (sub_award + fs_sub + outside_sub + fs_unsub + outside_unsub)
      if unsub_award > annual_loan_limit/2
        unsub_award = annual_loan_limit/2 - sub_award
      end
      if total_sub_borrowed + total_unsub_borrowed + sub_award + unsub_award >= loan_agg
        unsub_award = loan_agg - (total_sub_borrowed + total_unsub_borrowed + sub_award)
      end

      set_total_awards

      if total_awards > summer_budget
        unsub_award -= (total_awards - summer_budget)
      end

    else
      unsub_award = 0
    end
  end

  def check_unsub_over_budget
    if total_awards > summer_budget - summer_efc
      if unsub_award > 0
        unsub_award -= (total_awards - (summer_budget - summer_efc))
        if unsub_award < 0
          unsub_award = 0
        end
      end
      set_total_awards
    end
  end

  def check_sub_over_budget
    if total_awards > summer_budget - summer_efc
      if sub_award > 0
        sub_award -= (total_awards - (summer_budget - summer_efc))
        if sub_award < 0
          sub_award = 0
        end
      end
      set_total_awards
    end
  end

  def check_mdtus_over_budget
    if total_awards > summer_budget - summer_efc
      if mdtus > 0
        mdtus -= (total_awards - (summer_budget - summer_efc))
        if mdtus < 0
          mdtus = 0
        end
      end
      set_total_awards
    end
  end

  def check_pell_over_budget
    if total_awards > summer_budget - summer_efc
      if pell_award > 0
        pell_award -= (total_awards - (summer_budget - summer_efc))
        if pell_award < 0
          pell_award = 0
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

end
