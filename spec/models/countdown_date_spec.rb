describe CountdownDate do

  before do
    @time = Time.local(2012,1,2,3,4,5)
    @date = CountdownDate(@time)
  end

  it "is comparable" do
    @date.prevDay.should < @date
    @date.nextDay.should > @date
  end

  describe "#setFromTime" do
    it "sets the date from the given time's date" do
      @date.setFromTime(Time.local(2012,1,2,3,4,5))
      @date.toTime.should == Time.local(2012,1,2)
    end
  end

  describe "#to_s" do
    it "can format the date" do
      @date.to_s.should == "Mon January  2, 2012"
    end
  end

  describe "#nextDay" do
    it "can compute the next day" do
      nextDay = @date.nextDay
      nextDay.to_s.should == "Tue January  3, 2012"
    end

    it "can compute any number of days since the time" do
      nextDay = @date.nextDay(2)
      nextDay.to_s.should == "Wed January  4, 2012"
    end
  end

  describe "date - date" do
    it "can compute days between dates" do
      nextDay = @date.nextDay(5)
      (nextDay - @date).should == 5
    end
  end

  describe "#today?" do
    it "knows if a date is today" do
      CountdownDate(Time.now).today?.should == true
    end
  end

  describe "#nearestDayOfWeek" do
    it "returns a date counting back to a specific day of week by default" do
      newDay = @date.nearestDayOfWeek :saturday
      newDay.to_s.should == "Sat December 31, 2011"
    end

    it "can return a date counting forward" do
      newDay = @date.nearestDayOfWeek :saturday, forward: true
      newDay.to_s.should == "Sat January  7, 2012"
    end

    it "returns itself if it is the nearest day of the week" do
      newDay = @date.nearestDayOfWeek :monday
      newDay.to_s.should == "Mon January  2, 2012"
    end
  end

  describe ".deserialize" do
    it "loads the time value" do
      time = Time.local(2012,1,1)
      CountdownDate.deserialize(time).toTime.should == time
    end
  end

  describe "#serialize" do
    it "converts to a time" do
      time = Time.local(2012,1,1)
      CountdownDate(time).serialize.should == time
    end
  end

end
