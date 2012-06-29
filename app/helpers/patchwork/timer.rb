class Timer

  def self.after seconds, &block
    new seconds, &block
  end

  def initialize seconds, &block
    @seconds = seconds
    @block = block
    @nstimer = NSTimer.scheduledTimerWithTimeInterval(
      seconds,
      target: self,
      selector: 'call',
      userInfo: nil,
      repeats: false)
  end

  def stop
    @nstimer.invalidate if @nstimer
    @nstimer = nil
  end

  def call
    return unless @nstimer
    @nstimer.invalidate
    @nstimer = nil
    @block.call
  end

end
