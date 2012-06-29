describe CountdownCalculator do
  before do
    @calculator = CountdownCalculator.new
    @calculator.startTime = Time.local(2012,1,1)
    @calculator.endTime = Time.local(2012,1,6)
  end

  describe "#newWithStart:end" do
    it "makes a new one with the given start and end date" do
      startDate = CountdownDate(Time.local(2010,1,1))
      endDate = CountdownDate(Time.local(2010,2,2))
      @calculator = CountdownCalculator.newWithStart(startDate, end: endDate)
      @calculator.startDate.should == startDate
      @calculator.endDate.should == endDate
    end
  end

  describe "#daysLeft" do
    it "counts 5 days between 2012-1-1 and 2012-1-6" do
      @calculator.daysLeft.should == 5
    end

    it "counts 10 days between 2012-1-1 and 2012-1-11 14:30" do
      @calculator.endTime = Time.local(2012,1,11,14,30)
      @calculator.daysLeft.should == 10
    end
  end

  describe "#to_s" do
    it "has a string representation" do
      @calculator.to_s.should == "5 days"
    end

    it "says 'boom' on the last day" do
      @calculator.endTime = @calculator.startDate.toTime
      @calculator.to_s.should == 'boom'
    end
  end

  describe "#calculatorWithDaysBeforeEndTime" do
    it "returns a calculator any number of days from the end" do
      newCalc = @calculator.calculatorWithDaysBeforeEndTime 1
      newCalc.to_s.should == "1 day"
    end
  end

  describe "#includesDate?" do
    it "knows if a date is in the calculator range or not" do
      date = CountdownDate(Time.local(2012,1,3))
      @calculator.includesDate?(date).should == true
      date = CountdownDate(Time.local(2012,1,10))
      @calculator.includesDate?(date).should == false
    end
  end

  describe "#pastDate?" do
    it "knows if it is past the given date" do
      @calculator.pastDate?(CountdownDate.now).should == true
    end
  end

  describe "#lastDayOfWeek" do
    it "should be Saturday if first day is Sunday" do
      @calculator.firstDayOfWeek = :sunday
      @calculator.lastDayOfWeek.should == :saturday
    end

    it "should be Sunday if first day is Monday" do
      @calculator.firstDayOfWeek = :monday
      @calculator.lastDayOfWeek.should == :sunday
    end
  end

  describe "#weeksSpanned" do
    before do
      @calculator = CountdownCalculator.new
    end

    it "calculates 2 weeks from a Sunday to a Sunday" do
      @calculator.startTime = Time.local(2012, 1, 1)
      @calculator.endTime = Time.local(2012, 1, 8)
      @calculator.weeksSpanned.should == 2
    end

    it "calculates 3 weeks from a Sunday to a Sunday 2 weeks away" do
      @calculator.startTime = Time.local(2012, 1, 1)
      @calculator.endTime = Time.local(2012, 1, 15)
      @calculator.weeksSpanned.should == 3
    end

    it "calculates 2 weeks from a Sunday to the following Saturday" do
      @calculator.startTime = Time.local(2012, 1, 1)
      @calculator.endTime = Time.local(2012, 1, 14)
      @calculator.weeksSpanned.should == 2
    end

    it "calculates 2 weeks from a Saturday to the following Saturday" do
      @calculator.startTime = Time.local(2012, 1, 7)
      @calculator.endTime = Time.local(2012, 1, 14)
      @calculator.weeksSpanned.should == 2
    end

    it "calculates 2 weeks from a Sunday to Sunday when Monday is first day of week" do
      @calculator.firstDayOfWeek = :monday
      @calculator.startTime = Time.local(2012, 1, 1)
      @calculator.endTime = Time.local(2012, 1, 8)
      @calculator.weeksSpanned.should == 2
    end

    it "calculates to 0 if daysLeft is <= 0" do
      @calculator.startTime = Time.local(2012, 1, 3)
      @calculator.endTime = Time.local(2012, 1, 1)
      @calculator.weeksSpanned.should == 0
    end
  end

  describe "#startDateForWeekNum" do

    it "calculates the beginning date of week for a given number from start" do
      @calculator.startTime = Time.local(2012, 1, 5)
      @calculator.endTime = Time.local(2012, 6, 5)
      @calculator.startDateForWeekNum(2).to_s.should == "Sun January 15, 2012"
    end

  end

end
