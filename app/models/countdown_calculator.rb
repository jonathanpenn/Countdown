class CountdownCalculator
  attr_accessor :startDate, :endDate
  attr_accessor :firstDayOfWeek

  def self.newWithStart startDate, end: endDate
    new.tap do |c|
      c.startDate = startDate
      c.endDate = endDate
    end
  end

  def firstDayOfWeek
    @firstDayOfWeek ||= :sunday
  end

  def lastDayOfWeek
    firstDayNum = CountdownDate::DAYS_OF_WEEK.index(firstDayOfWeek.to_s)
    lastDayNum = (firstDayNum + 6) % CountdownDate::DAYS_OF_WEEK.length
    CountdownDate::DAYS_OF_WEEK[lastDayNum].to_sym
  end

  def startTime= newTime
    self.startDate = CountdownDate(newTime)
  end

  def endTime= newTime
    self.endDate = CountdownDate(newTime)
  end

  def startDate= newDate
    @startDate = newDate
  end

  def endDate= newDate
    @endDate = newDate
  end

  def daysLeft
    endDate - startDate
  end

  def calculatorWithDaysBeforeEndTime days
    calculator = self.class.new
    calculator.endDate = endDate
    calculator.startDate = endDate.prevDay(days)
    calculator
  end

  def includesDate? date
    date >= startDate && date <= endDate
  end

  def pastDate? countdownDate
    endDate < countdownDate
  end

  def to_s
    if daysLeft == 0
      'boom'
    else
      "%d day%s" % [daysLeft, daysLeft == 1 ? '' : 's']
    end
  end

  def weeksSpanned
    if daysLeft <= 0
      0
    else
      firstDate = startDate.nearestDayOfWeek(firstDayOfWeek)
      lastDate = endDate.nearestDayOfWeek(lastDayOfWeek, forward: true)
      ((lastDate - firstDate) / 7.0).ceil
    end
  end

  def startDateForWeekNum weekNum
    startDate.nearestDayOfWeek(firstDayOfWeek).nextDay(weekNum*7)
  end

end
