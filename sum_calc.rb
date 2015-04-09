#Loans
dep1sub = 3500
dep1Total = 5500
dep2sub = 4500
dep2Total = 6500
dep3sub = 5500
dep3Total = 7500
ind1sub = 3500
ind1Total = 9500
ind2sub = 4500
ind2Total = 10500
ind3sub = 5500
ind3Total = 12500

annualPell = 5730
subAgg = 23000
loanAgg = 57500

puts "Type 1 for new calculation or press any other key to exit."
action = gets.chomp

while action == "1"

  #ROASTAT
  puts "Is student TASFA? (y/n): "
  tasfa = gets.chomp
  while tasfa != "y" && tasfa != "n"
    puts "Is student TASFA? (y/n): "
    tasfa = gets.chomp
  end

  puts "Please enter dependency status (dep/ind): "
  depStatus = gets.chomp

  puts "\nPlease enter old budget: "
  oldBudget = gets.chomp.to_i

  puts "\nPlease enter old EFC: "
  oldEfc = gets.chomp.to_i

  puts "Please enter SAP status (good/bad): "
  sapStatus = gets.chomp
  while sapStatus != "good" && sapStatus != "bad"
    endputs "Please enter SAP status (good/bad): "
    sapStatus = gets.chomp
  end
  if sapStatus == "bad"
    puts "\n***Please check student after SAP is reviewed - Add ROAMESG***"
    redo
  end

  #RPAAWRD
  if tasfa == "n"
    puts "Please enter Fall Pell: "
    fallPell = gets.chomp.to_i

    puts "Please enter Spring Pell: "
    springPell = gets.chomp.to_i

    puts "Please enter Fall Sub: "
    fallSub = gets.chomp.to_i

    puts "Please enter Spring Sub: "
    springSub = gets.chomp.to_i

    puts "Please enter Fall Unsub: "
    fallUnsub = gets.chomp.to_i

    puts "Please enter Spring Unsub: "
    springUnsub = gets.chomp.to_i
  end

  #ROAENRL
  puts "Please enter Fall enrollment: "
  fallEnrollment = gets.chomp.to_i

  puts "Please enter Spring enrollment: "
  springEnrollment = gets.chomp.to_i

  #RNASL
  if tasfa == "n"
    puts "Please enter LEU: "
    pellLeu = gets.chomp.to_f

    puts "Please enter total Sub borrowed: "
    totalSub = gets.chomp.to_i

    puts "Please enter total Unsub borrowed: "
    totalUnsub = gets.chomp.to_i
    totalLoans = totalSub + totalUnsub

    if fallEnrollment == 0 || springEnrollment == 0
      puts "\n***Please check NSLDS and add student to TM***"
      gets
    end
    if pellLeu >= 500
      puts "\n***Please confirm Pell LEU on NSLDS***"
      puts "LEU on NSLDS: "
      pellLeu = gets.chomp.to_f
    end

    if totalLoans > loanAgg || totalSub > subAgg
      puts "\n***Loan limits exceeded***"
      gets
    end
  end

  #RBAPBUD
  puts "Please enter summer budget: "
  summerBudget = gets.chomp.to_i
  newBudget = oldBudget + summerBudget

  puts "\n***New budget is: " + newBudget.to_s + "***"
  gets

  #RNIMS
  #M11 for FA/SPR, M7 for FA or SPR, M2 for sum only
  puts "Please enter new EFC: "
  newEfc = gets.chomp.to_i

  while newEfc < oldEfc
    puts "new EFC must be larger than or equal to old EFC."
    puts "\nPlease enter old EFC: "
    oldEfc = gets.chomp.to_i

    puts "Please enter new EFC: "
    newEfc = gets.chomp.to_i
  end

  sumEfc = newEfc - oldEfc

  puts "\n***Summer EFC is: " + sumEfc.to_s + "***"
  gets

  #WADVISE
  puts "\nPlease enter student grade level (1, 2, 3, or 4): "
  gradeLevel = gets.chomp.to_i

  #ROAUSDF
  puts "\n***Please input in ROAUSDF: LEU, Summer hours, budget, and EFC***"
  puts "\nLEU: " + pellLeu.to_s + " \nSummer budget: " + summerBudget.to_s + " \nSummer EFC: " + sumEfc.to_s
  gets

  #RPAAWRD
  puts "\nStudent should be awarded: "
  if tasfa == "n"
    if oldEfc <= 5100
      pellFactor = (oldEfc - 1)/100
      if pellFactor == 1
        annualPell -= 50
      elsif pellFactor > 1
        annualPell -= 50 + pellFactor*100
      else
      end
    elsif oldEfc >= 5101 && oldEfc <= 5157
      annualPell = 602
    else
      annualPell = 0
    end

    if pellLeu >= 575
      pellAward = ((600 - pellLeu) * 0.01) * annualPell
    elsif annualPell - (fallPell + springPell) <= 1433
      pellAward = annualPell - (fallPell + springPell)
    else
      pellAward = 1433
    end

    if pellAward < 1000
      mdtus = 1500 - pellAward
    else
      mdtus = 0
    end

    if depStatus == "ind"
      case gradeLevel
      when 1
        annualSubLim = ind1sub
        annualLoanLim = ind1Total
      when 2
        annualSubLim = ind2sub
        annualLoanLim = ind2Total
      else
        annualSubLim = ind3sub
        annualLoanLim = ind3Total
      end
    else
      case gradeLevel
      when 1
        annualSubLim = dep1sub
        annualLoanLim = dep1Total
      when 2
        annualSubLim = dep2sub
        annualLoanLim = dep2Total
      else
        annualSubLim = dep3sub
        annualLoanLim = dep3Total
      end
    end

    if fallSub + springSub > 0 && fallSub + springSub < annualSubLim
      subAward = annualSubLim - fallSub - springSub
      if subAward > annualSubLim/2
        subAward = annualSubLim/2
      end
      if totalSub + subAward >= subAgg
        subAward = subAgg - totalSub
      end
    else
      subAward = 0
    end

    if fallUnsub + springUnsub > 0 && fallUnsub + springUnsub < annualLoanLim - (fallSub + springSub)
      unsubAward = annualLoanLim - (subAward + fallSub + springSub + fallUnsub + springUnsub)
      if unsubAward > annualLoanLim/2
        unsubAward = annualLoanLim/2 - subAward
      end
      if totalLoans + subAward + unsubAward >= loanAgg
        unsubAward = loanAgg - (totalLoans + subAward)
      end

      totalAwards = pellAward + subAward + unsubAward + mdtus

      if totalAwards > summerBudget
        unsubAward -= (totalAwards - summerBudget)
      end

    else
      unsubAward = 0
    end

  else
    pellAward = 0
    mdtus = 1500
    subAward = 0
    unsubAward = 0
  end

  puts "\nPell: " + pellAward.to_s
  puts "MDTUS: " + mdtus.to_s
  puts "Sub Loans: " + subAward.to_s
  puts "Unsub Loans: " + unsubAward.to_s
  if subAward + unsubAward + pellAward == 0 && mdtus > 0
    puts "\n***Make sure to check award letter***"
  end
  gets

  #RRAAREQ
  if fallEnrollment == 0 && springEnrollment == 0
    puts "\n***Please satisfy docs on RRAAREQ and add TC***"
    gets
  else
    puts "\n***Please satisfy docs on RRAAREQ***"
    gets
  end

  totalAwards = pellAward + subAward + unsubAward + mdtus

  #ROAMESG
  if totalAwards == 0
    puts "\n***Please add ROAMESG***"
    gets
  end

  puts "\nFill out sum app form: "
  puts "SAP: " + sapStatus.to_s + "\nFall Pell: " + fallPell.to_s + "\nSpring Pell: " + springPell.to_s + "\nNew Budget: " + newBudget.to_s + "\nOld Budget: " + oldBudget.to_s + "\nSummer Budget: " + summerBudget.to_s + "\nNew EFC: " + newEfc.to_s + "\nOld EFC: " + oldEfc.to_s + "\nSummer EFC: " + sumEfc.to_s + "\nSummer Pell: " + pellAward.to_s + "\nSummer Sub: " + subAward.to_s + "\nSummer Unsub: " + unsubAward.to_s + "\nMDTUS: " + mdtus.to_s

  puts
  puts "Type 1 for new calculation or press any other key to exit."
  action = gets.chomp
end
