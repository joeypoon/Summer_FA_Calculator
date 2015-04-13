require_relative "aid_calculations"

class Testing < AidCalculations

  def test
    self.test_tasfa
    self.test_dependency_status
    self.test_grade_level
    self.test_old_budget
    self.test_old_efc
    self.test_pell_efc
    self.test_sap_status
    self.test_fs_pell
    self.test_fs_sub
    self.test_fs_unsub
    self.test_fall_enrollment
    self.test_spring_enrollment
    self.test_pell_leu
    self.test_total_sub_borrowed
    self.test_total_unsub_borrowed
    self.test_summer_budget
    self.test_new_efc

    self.calculate_awards
    self.display_awards
    self.display_stats
  end

  def test_tasfa
    random = rand(5) #tasfa students are less common
    if random == 0
      self.tasfa = "y"
    else
      self.tasfa = "n"
    end
  end

  def test_dependency_status
    random = rand(2)
    if random == 0
      self.dependency_status = "dep"
    else
      self.dependency_status = "ind"
    end
  end

  def test_old_budget
    random = rand(3)
    @one_semester = 10993
    @two_semesters = 22000
    if random == 0
      self.old_budget = 0
    elsif random == 1
      self.old_budget = @one_semester
    else
      self.old_budget = @two_semesters
    end
  end

  def test_old_efc
    @max_efc = 6000 #max is 999999 but most are 0 and generally do not exceed 20000 in which case there is little practical difference
    @half_efc = @max_efc * 0.6 #not really half because costs are not perfectly halved
    if self.old_budget == 0
      self.old_efc = 0
    elsif self.old_budget == @one_semester
      self.old_efc = rand(@half_efc)
    else
      self.old_efc = rand(@max_efc)
    end
  end

  #private

  def test_pell_efc
    self.old_efc = rand(@max_efc)
  end

  def test_sap_status
    if rand(10) == 0 #sap don't qualify so not as useful to test many
      self.sap_status = "bad"
    else
      self.sap_status = "good"
    end
  end

  def test_fs_pell
    self.fs_pell = rand(self.annual_pell) + 1
  end

  def test_fs_sub
    self.set_annual_loan_limits
    self.fs_sub = rand(self.annual_sub_limit) + 1
  end

  def test_fs_unsub
    self.fs_unsub = rand(self.annual_loan_limit - self.fs_sub) + 1
  end

  def test_fall_enrollment
    self.fall_enrollment = rand(16)
  end

  def test_spring_enrollment
    self.spring_enrollment = rand(16)
  end

  def test_pell_leu
    self.pell_leu = rand(601)
  end

  def test_total_sub_borrowed
    self.total_sub_borrowed = rand(self.sub_agg)
  end

  def test_total_unsub_borrowed
    self.total_unsub_borrowed = rand(self.loan_agg - self.total_sub_borrowed)
  end

  def test_summer_budget
    off_campus = 6947
    with_parents = 5525
    if rand(2) == 0
      self.summer_budget = with_parents
    else
      self.summer_budget = off_campus
    end
  end

  def test_new_efc
    if rand(2) == 0
      self.new_efc = self.old_efc
    else
      self.new_efc = self.old_efc + self.old_efc * 0.01
    end
  end

  def test_grade_level
    self.grade_level = rand(6) + 1
  end

end

for i in 1..3
  puts "Test student #{i}"
  student = Testing.new
  student.test_grade_level
  puts student.grade_level
end
