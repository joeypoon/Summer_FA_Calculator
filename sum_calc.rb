require_relative "aid_calculations"

puts "Enter 1 to continue or press any other key to exit."
action = gets.chomp

while action == "1"

  student = AidCalculations.new
  student.ask_tasfa
  student.ask_dependency_status
  student.ask_old_budget
  student.ask_old_efc

  if !student.is_tasfa?
    student.ask_pell_efc
  end

  student.ask_sap

  if student.is_sap?
    puts "\n***Please re-review application after SAP is reviewed***"
    redo
  end

  if !student.is_tasfa?
    student.ask_fs_pell
    student.ask_fs_sub
    student.ask_fs_unsub
  end

  student.ask_fall_enrollment
  student.ask_spring_enrollment

  if !student.is_tasfa?
    student.ask_leu
    student.ask_total_sub_borrowed
    student.ask_total_unsub_borrowed
    student.check_leu
    student.check_loan_limits
  end

  student.check_enrollment
  student.ask_summer_budget
  #student.set_new_budget  #optional

  student.ask_new_efc
  student.check_efc
  student.ask_grade_level

  puts "\n***Please input in ROAUSDF: LEU, Summer hours, budget, and EFC***"
  puts "\nLEU: " + student.pell_leu.to_s + " \nSummer budget: " + student.summer_budget.to_s + " \nSummer EFC: " + student.summer_efc.to_s
  gets

  student.calculate_awards

  puts "\nStudent should be awarded: "
  student.display_awards
  #student.display_stats  #optional

  puts "\nEnter 1 to continue or press any other key to exit"
  action = gets.chomp

end
