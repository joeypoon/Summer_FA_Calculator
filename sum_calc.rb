#2014-2015 Annual Limits
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
gradTotal = 20500
annualPell = 5730

#2014-2015 Aggregate Limits
subAgg = 23000
loanAgg = 57500
gradAgg = 138500

#Default values
outsidePell = 0
outsideSub = 0
outsideUnsub = 0

def validateInt input
  if (Integer(input) rescue nil) != input.to_i
    return false
  else
    return true
  end
end

def validateFloat input
  if (Float(input) rescue nil) != input.to_f
    return false
  else
    return true
  end
end

begin

  puts "Type 1 for new calculation or press any other key to exit."
  action = gets.chomp

  #ROASTAT
  begin
    puts "\nIs student TASFA? (y/n): "
    tasfa = gets.chomp
  end until tasfa == "y" || tasfa == "n"

  begin
    puts "\nPlease enter dependency status (dep/ind): "
    depStatus = gets.chomp
  end until depStatus == "dep" || depStatus == "ind"

  begin
    puts "\nPlease enter old budget: "
    oldBudget = gets.chomp
  end until validateInt oldBudget
  oldBudget = oldBudget.to_i

  begin
    puts "\nPlease enter old EFC: "
    oldEfc = gets.chomp
  end until validateInt oldEfc
  oldEfc = oldEfc.to_i

  begin
    puts "\nPlease enter Pell EFC: "
    pellEfc = gets.chomp
  end until validateInt pellEfc
  pellEfc = pellEfc.to_i

  begin
    puts "\nPlease enter SAP status (good/bad): "
    sapStatus = gets.chomp
  end until sapStatus == "good" || sapStatus == "bad"

  if sapStatus == "bad"
    puts "\n***Please check student after SAP is reviewed - Add ROAMESG***"
    redo
  end

  #RPAAWRD
  if tasfa == "n"
    begin
      puts "\nPlease enter Fall + Spring Pell: "
      fsPell = gets.chomp
    end until validateInt fsPell
    fsPell = fsPell.to_i

    begin
      puts "\nPlease enter Fall + Spring Sub: "
      fsSub = gets.chomp
    end until validateInt fsSub
    fsSub = fsSub.to_i

    begin
      puts "\nPlease enter Fall + Spring Unsub: "
      fsUnsub = gets.chomp
    end until validateInt fsUnsub
    fsUnsub = fsUnsub.to_i

  #ROAENRL
    begin
      puts "\nPlease enter Fall enrollment: "
      fallEnrollment = gets.chomp
    end until validateInt fallEnrollment
    fallEnrollment = fallEnrollment.to_i

    begin
      puts "\nPlease enter Spring enrollment: "
      springEnrollment = gets.chomp
    end until validateInt springEnrollment
    springEnrollment = springEnrollment.to_i

  #RNASL
    begin
      puts "\nPlease enter LEU: "
      pellLeu = gets.chomp
    end until validateFloat pellLeu
    pellLeu = pellLeu.to_f

    begin
      puts "\nPlease enter total Sub borrowed: "
      totalSub = gets.chomp
    end until validateInt totalSub
    totalSub = totalSub.to_i

    begin
      puts "\nPlease enter total Unsub borrowed: "
      totalUnsub = gets.chomp
    end until validateInt totalUnsub
    totalUnsub = totalUnsub.to_i

    totalLoans = totalSub + totalUnsub

    if fallEnrollment == 0 || springEnrollment == 0
      puts "\n***Please check NSLDS and add student to TM***"

      begin
        puts "\nEnter amount of outside Pell: "
        outsidePell = gets.chomp
      end until validateInt outsidePell
      outsidePell = outsidePell.to_i

      begin
        puts "\nEnter amount of outside sub: "
        outsideSub = gets.chomp
      end until validateInt outsideSub
      outsideSub = outsideSub.to_i

      begin
        puts "\nEnter amount of outside unsub: "
        outsideUnsub = gets.chomp
      end until validateInt outsideUnsub
      outsideUnsub = outsideUnsub.to_i

    end

    if pellLeu >= 500
      puts "\n***Please confirm Pell LEU on NSLDS***"
      begin
        puts "LEU on NSLDS: "
        pellLeu = gets.chomp
      end until validateFloat pellLeu
      pellLeu = pellLeu.to_f
    end

    if totalLoans > loanAgg || totalSub > subAgg
      puts "\n***Loan limits exceeded***"
      gets
    end
  end

  #RBAPBUD
  begin
    puts "\nPlease enter Summer budget: "
    summerBudget = gets.chomp
  end until validateInt summerBudget
  summerBudget = summerBudget.to_i

  newBudget = oldBudget + summerBudget

  #RNIMS
  begin
    puts "\nPlease enter new EFC: "
    newEfc = gets.chomp
  end until validateInt newEfc
  newEfc = newEfc.to_i

  while newEfc < oldEfc
    puts "\nNew EFC must be larger than or equal to old EFC."
    begin
      puts "\nPlease enter old EFC: "
      oldEfc = gets.chomp
    end until validateInt oldEfc
    oldEfc = oldEfc.to_i

    begin
      puts "\nPlease enter new EFC: "
      newEfc = gets.chomp
    end until validateInt newEfc
    newEfc = newEfc.to_i
  end

  sumEfc = newEfc - oldEfc

  #WADVISE
  begin
    puts "\nPlease enter student grade level (1, 2, 3, 4, 5, or 6): "
    gradeLevel = gets.chomp.to_i
  end until gradeLevel >= 1 && gradeLevel <= 6

  #ROAUSDF
  puts "\n***Please input in ROAUSDF: LEU, Summer hours, budget, and EFC***"
  puts "\nLEU: " + pellLeu.to_s + " \nSummer budget: " + summerBudget.to_s + " \nSummer EFC: " + sumEfc.to_s
  gets

  #RPAAWRD
  puts "\nStudent should be awarded: "
  if tasfa == "n"
    if fallEnrollment + springEnrollment >= 24
      pellAward = 0
    else
      if pellEfc > 5157
        annualPell = 0
      elsif pellEfc >= 5101 && pellEfc <= 5157
        annualPell = 602
      elsif pellEfc > 100 && pellEfc <= 5100
        pellFactor = (pellEfc - 1) / 100
        annualPell = annualPell - (50 + pellFactor * 100)
      elsif pellEfc > 0 && pellEfc <= 100
        annualPell = annualPell - 50
      end

      if pellLeu > 575
        pellAward = ((600 - pellLeu) * 0.01) * annualPell
      else
        pellAward = annualPell - (fsPell + outsidePell)
        if pellAward > annualPell / 4
          pellAward = annualPell / 4
        end
      end
    end

    if gradeLevel > 4
      pellAward = 0
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
      when 3..5
        annualSubLim = ind3sub
        annualLoanLim = ind3Total
      when 6
        annualSubLim = 0
        annualLoanLim = gradTotal
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

    if fsSub > 0 && fsSub + outsideSub < annualSubLim
      if fsSub + outsideSub + fsUnsub + outsideUnsub < annualLoanLim
        subAward = annualSubLim - (fsSub + outsideSub)
        if subAward > annualSubLim/2
          subAward = annualSubLim/2
        end
        if totalSub + subAward >= subAgg
          subAward = subAgg - totalSub
        end

      else
        subAward = 0
      end

    else
      subAward = 0
    end

    if fsUnsub > 0 && fsUnsub < annualLoanLim - (fsSub + outsideSub)
      unsubAward = annualLoanLim - (subAward + fsSub + outsideSub + fsUnsub + outsideUnsub)
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

    totalAwards = pellAward + mdtus + subAward + unsubAward

  else
    pellAward = 0
    mdtut = 1500
    subAward = 0
    unsubAward = 0
    totalAwards = mdtut
  end

  if totalAwards > summerBudget - sumEfc
    if unsubAward > 0
      unsubAward -= (totalAwards - (summerBudget - sumEfc))
      if unsubAward < 0
        unsubAward = 0
      end
    end
    totalAwards = pellAward + mdtus + subAward + unsubAward
  end

  if totalAwards > summerBudget - sumEfc
    if subAward > 0
      subAward -= (totalAwards - (summerBudget - sumEfc))
      if subAward < 0
        subAward = 0
      end
    end
    totalAwards = pellAward + mdtus + subAward + unsubAward
  end

  while totalAwards > summerBudget - sumEfc
    if mdtus > 0
      mdtus -= (totalAwards - (summerBudget - sumEfc))
      if mdtus < 0
        mdtus = 0
      end
    end
    totalAwards = pellAward + mdtus + subAward + unsubAward
  end

  while totalAwards > summerBudget - sumEfc
    if pellAward > 0
      pellAward -= (totalAwards - (summerBudget - sumEfc))
      if pellAward < 0
        pellAward = 0
      end
    end
    totalAwards = pellAward + mdtus + subAward + unsubAward
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

  puts "\n\nType 1 for new calculation or press any other key to exit."
  action = gets.chomp

end until action != "1"
