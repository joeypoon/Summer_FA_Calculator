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
    puts "\nIs student TASFA? (y/n): "
    tasfa = gets.chomp
  end

  puts "\nPlease enter dependency status (dep/ind): "
  depStatus = gets.chomp

  puts "\nPlease enter old budget: "
  oldBudget = gets.chomp.to_i

  puts "\nPlease enter old EFC: "
  oldEfc = gets.chomp.to_i

  puts "\nPlease enter SAP status (good/bad): "
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
    puts "\nPlease enter Fall + Spring Pell: "
    fsPell = gets.chomp.to_i

    puts "\nPlease enter Fall + Spring Sub: "
    fsSub = gets.chomp.to_i

    puts "\nPlease enter Fall + Spring Unsub: "
    fsUnsub = gets.chomp.to_i
  end

  #ROAENRL
  puts "\nPlease enter Fall enrollment: "
  fallEnrollment = gets.chomp.to_i

  puts "\nPlease enter Spring enrollment: "
  springEnrollment = gets.chomp.to_i

  #RNASL
  if tasfa == "n"
    puts "\nPlease enter LEU: "
    pellLeu = gets.chomp.to_f

    puts "\nPlease enter total Sub borrowed: "
    totalSub = gets.chomp.to_i

    puts "\nPlease enter total Unsub borrowed: "
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
  puts "\nPlease enter summer budget: "
  summerBudget = gets.chomp.to_i
  newBudget = oldBudget + summerBudget

  puts "\n***New budget is: " + newBudget.to_s + "***"
  gets

  #RNIMS
  #M11 for FA/SPR, M7 for FA or SPR, M2 for sum only
  puts "\nPlease enter new EFC: "
  newEfc = gets.chomp.to_i

  while newEfc < oldEfc
    puts "\nnew EFC must be larger than or equal to old EFC."
    puts "\nPlease enter old EFC: "
    oldEfc = gets.chomp.to_i

    puts "\nPlease enter new EFC: "
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
    else
      pellAward = (annualPell - (fsPell)) * 0.5
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

    if fsSub > 0 && fsSub < annualSubLim
      subAward = annualSubLim - fsSub
      if subAward > annualSubLim/2
        subAward = annualSubLim/2
      end
      if totalSub + subAward >= subAgg
        subAward = subAgg - totalSub
      end
    else
      subAward = 0
    end

    if fsUnsub > 0 && fsUnsub < annualLoanLim - fsSub
      unsubAward = annualLoanLim - (subAward + fsSub + fsUnsub)
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
    mdtut = 1500
    subAward = 0
    unsubAward = 0
  end

  puts "\nPell: " + pellAward.to_s
  if tasfa == "n"
    puts "MDTUS: " + mdtus.to_s
  else
    puts "MDTUT: " + mdtut.to_s
  end
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
  puts "SAP: " + sapStatus.to_s + "\nFall + Spring Pell: " + fsPell.to_s + "\nNew Budget: " + newBudget.to_s + "\nOld Budget: " + oldBudget.to_s + "\nSummer Budget: " + summerBudget.to_s + "\nNew EFC: " + newEfc.to_s + "\nOld EFC: " + oldEfc.to_s + "\nSummer EFC: " + sumEfc.to_s + "\nSummer Pell: " + pellAward.to_s + "\nSummer Sub: " + subAward.to_s + "\nSummer Unsub: " + unsubAward.to_s + "\nMDTUS: " + mdtus.to_s

  puts
  puts "Type 1 for new calculation or press any other key to exit."
  action = gets.chomp
end
