class Config

  def self.countdownCollection
    CountdownCollection.deserialize(defaults['countdownCollection'] || [])
  end

  def self.countdownCollection= collection
    defaults['countdownCollection'] = collection.serialize
    defaults.synchronize
  end

  def self.selectedCountdownIndex
    defaults['selectedCountdownIndex']
  end

  def self.selectedCountdownIndex= index
    defaults['selectedCountdownIndex'] = index
    defaults.synchronize
  end

  def self.whenLastShownSwipeInstructions
    defaults['whenLastShownSwipeInstructions'] || NSDate.dateWithTimeIntervalSince1970(0)
  end

  def self.whenLastShownSwipeInstructions= date
    defaults['whenLastShownSwipeInstructions'] = date
    defaults.synchronize
  end


  private

  def self.defaults
    @defaults ||= NSUserDefaults.standardUserDefaults
  end
end
