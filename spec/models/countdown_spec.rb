describe Countdown do

  it "defaults with a blank name string for today" do
    c = Countdown.new
    c.endDate.should == CountdownDate.now
    c.name.should == ''
  end

  describe "#newWithName:endDate" do
    it "initializes the countdown attributes" do
      time = Time.local(2010,1,1)
      @countdown = Countdown.newWithName 'name', endTime: time
      @countdown.name.should == 'name'
      @countdown.endDate.== CountdownDate(time)
    end
  end

  describe "#endTime = " do
    it "creates a countdown date from the passed time" do
      @countdown = Countdown.new
      @countdown.endTime = Time.local(2010,1,1)
      @countdown.endDate.should == CountdownDate(Time.local(2010,1,1))
    end
  end

  describe "#serialize" do
    it "converts the attributes to dictionaries" do
      date = CountdownDate.now
      def date.serialize; 'when it happens' end

      @countdown = Countdown.new
      @countdown.endDate = date
      @countdown.name = "serialize me!"

      @countdown.serialize.should == {
        'endDate' => 'when it happens',
        'name' => 'serialize me!'
      }
    end
  end

  describe ".deserialize" do
    it "converts a dictionary into a countdown" do
      data = {
        'endDate' => Time.local(2010,1,1),
        'name'    => 'countdown name'
      }

      @countdown = Countdown.deserialize(data)
      @countdown.endDate.should == CountdownDate(Time.local(2010,1,1))
      @countdown.name.should == 'countdown name'
    end
  end

  it "is comparable" do
    c1 = Countdown.new; c1.endTime = Time.local(2012,2,1)
    c2 = Countdown.new; c2.endTime = Time.local(2012,1,1)
    c1.should > c2
  end

end
