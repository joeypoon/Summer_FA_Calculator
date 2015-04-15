module Testing

  def test
    test_tasfa
    test_dependency_status
    test_grade_level
    test_old_budget
    test_old_efc
    test_pell_efc
    test_sap_status
    if is_sap
      exit
    end
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

  private

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
