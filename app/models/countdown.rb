class Countdown
  include Comparable

  attr_accessor :name, :endDate
  attr_accessor :collection

  def initialize
    self.name = ''
    self.endDate = CountdownDate.now
  end

  def self.newWithName name, endTime: time
    c = new
    c.name = name
    c.endTime = time
    c
  end

  def endTime= time
    self.endDate = CountdownDate(time)
  end

  def serialize
    {
      'endDate' => endDate.serialize,
      'name' => name
    }
  end

  def self.deserialize data
    c = new
    c.name = data['name']
    c.endDate = CountdownDate.deserialize(data['endDate'])
    c
  end

  def <=> otherCountdown
    endDate <=> otherCountdown.endDate
  end

end
