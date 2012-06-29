class CountdownCollection

  def initialize
    @array = []
  end

  def index countdown
    @array.index(countdown)
  end

  def insert countdown
    @array << countdown
    sort!
    self
  end

  def deleteAt index
    @array.delete_at index
  end

  def [] index
    @array[index]
  end

  def length
    @array.length
  end

  def save
    sort!
    Config.countdownCollection = self
  end

  def serialize
    @array.map do |countdown|
      countdown.serialize
    end
  end

  def sort!
    @array = @array.sort
  end

  def self.deserialize data
    c = new
    array = data.reduce([]) do |result, record|
      countdown = Countdown.deserialize(record)
      countdown.collection = c
      result << countdown
      result
    end
    c.instance_variable_set '@array', array
    c
  end

end
