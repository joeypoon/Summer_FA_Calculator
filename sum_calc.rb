require_relative "aid_calculations"

puts "Enter 1 to continue or press any other key to exit."
action = gets.chomp

while action == "test"
  student = AidCalculations.new
  student.test

  puts "\nEnter 1 to continue or press any other key to exit"
  action = gets.chomp
end

while action == "1"

  student = AidCalculations.new
  
  student.ask_sap
  if @sap_status == "bad"
    puts "\n***Please re-review application after SAP is reviewed***"
    redo
  end

  student.get_info

  student.display_roausdf
  gets

  student.calculate_awards

  puts "\nStudent should be awarded: "
  student.display_awards
  #student.display_stats  #optional

  puts "\nEnter 1 to continue or press any other key to exit"
  action = gets.chomp

end
