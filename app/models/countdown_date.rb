class CountdownDate
  include Comparable

  DAYS_OF_WEEK = %w[sunday monday tuesday wednesday thursday friday saturday]
  SECONDS_IN_A_DAY = 60 * 60 * 24

  def self.now
    new
  end


  def initialize time=nil
    setFromTime time || Time.now
  end

  def setFromTime time
    @time = Time.local(time.year, time.month, time.day)
  end

  def prevDay count=1
    self.nextDay 0-count
  end

  def nextDay count=1
    CountdownDate(@time + (SECONDS_IN_A_DAY * count))
  end

  def nearestDayOfWeek dayOfWeek, options={}
    return self if self.dayOfWeek == dayOfWeek

    forward = options.fetch(:forward, false)

    date = self
    loop do
      date = forward ? date.nextDay : date.prevDay
      return date if date.dayOfWeek == dayOfWeek
    end
  end

  def dayOfWeek
    DAYS_OF_WEEK[toTime.wday].to_sym
  end

  def to_s
    @time.strftime("%a %B %e, %Y")
  end

  def - otherDate
    ((toTime - otherDate.toTime) / SECONDS_IN_A_DAY).to_i
  end

  def toTime
    @time
  end

  def <=> otherDate
    toTime <=> otherDate.toTime
  end

  def today?
    self == self.class.now
  end

  def self.deserialize time
    new time
  end

  def serialize
    toTime
  end

end

def CountdownDate(time)
  CountdownDate.new(time)
end
