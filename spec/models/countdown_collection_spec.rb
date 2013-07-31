describe CountdownCollection do
  before do
    @collection = CountdownCollection.new
  end

  describe "#insert" do
    it "inserts a countdown in the sorted order" do
      first = Countdown.newWithName 'first', endTime: Time.local(2012,1,2)
      second = Countdown.newWithName 'second', endTime: Time.local(2012,2,2)
      @collection.insert second
      @collection[0].should == second
      @collection.insert first
      @collection[0].should == first
      @collection[1].should == second
    end
  end

  describe "#index" do
    it "returns the index of the given countdown" do
      first = Countdown.newWithName 'first', endTime: Time.local(2012,1,2)
      second = Countdown.newWithName 'second', endTime: Time.local(2012,2,2)
      @collection.insert second
      @collection.insert first

      @collection.index(first).should == 0
      @collection.index(second).should == 1
    end
  end

  describe "#deleteAt" do
    it "removes the given countdown index" do
      first = Countdown.newWithName 'first', endTime: Time.local(2012,1,2)
      second = Countdown.newWithName 'second', endTime: Time.local(2012,2,2)
      @collection.insert second
      @collection.insert first
      @collection.deleteAt(0)
      @collection.length.should == 1
      @collection[0].should == second
    end
  end

  describe "#serialize" do
    it "serializes the collection to an array" do
      first = Countdown.newWithName 'first', endTime: Time.local(2012,1,2)
      second = Countdown.newWithName 'second', endTime: Time.local(2012,2,2)
      @collection.insert first
      @collection.insert second
      @collection.serialize.map{|c| c['name']}.should == [
        'first',
        'second'
      ]
    end
  end

  describe ".deserialize" do
    it "converts an array into a countdown collection" do

      rec1 = Countdown.new
      rec2 = Countdown.new

      data = [
        rec1.serialize,
        rec2.serialize
      ]
      @collection = CountdownCollection.deserialize(data)
      @collection[0].should == rec1
      @collection[1].should == rec2
    end
  end

end
