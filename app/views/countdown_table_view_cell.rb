class CountdownTableViewCell < UITableViewCell
  attr_accessor :nameLabel, :countdownLabel, :dateLabel
  attr_accessor :countdownCalculator, :countdown

  def self.cell
    alloc.initWithStyle(UITableViewCellStyleDefault,
                        reuseIdentifier: name)
  end

  def initWithStyle style, reuseIdentifier: identifier
    super

    self.nameLabel = CustomLabel.alloc.initWithFrame [[0,0],[bounds.size.width,50]]
    nameLabel.alpha = 0.4
    self.countdownLabel = CountdownLabel.alloc.initWithFrame [[0,0],[bounds.size.width,80]]
    self.dateLabel = CustomLabel.alloc.initWithFrame [[0,0],[bounds.size.width,50]]
    self.distance = 1

    addSubview countdownLabel
    addSubview dateLabel
    addSubview nameLabel

    self
  end

  def countdownCalculator= newCountdownCalculator
    @countdownCalculator = newCountdownCalculator
    countdownLabel.text = countdownCalculator.to_s
    if countdownCalculator.endDate.today?
      dateLabel.text = "it's " + countdownCalculator.endDate.to_s
    else
      dateLabel.text = "til " + countdownCalculator.endDate.to_s
    end
    setNeedsLayout
  end

  def countdown= countdown
    @countdown = countdown
    nameLabel.text = countdown.name
  end

  def distance= newDistance
    @distance = newDistance
    dateLabel.alpha = [@distance - 0.6, 0.4].min
    updatePositioning
  end

  def layoutSubviews
    super
    updatePositioning
  end

  def updatePositioning
    size = bounds.size
    countdownLabel.center = [size.width/2, size.height/2+countdownLabelCenterOffset]
    dateLabel.center = [size.width/2, size.height/2+dateLabelCenterOffset]
    nameLabel.center = [size.width/2, size.height/2+nameLabelCenterOffset]
  end

  def dateLabelCenterOffset
    adjust = countdownLabel.bounds.size.height / 2.5
    adjust += ((1-@distance)*50)
    adjust
  end

  def countdownLabelCenterOffset
    0-countdownLabel.bounds.size.height / 2
  end

  def nameLabelCenterOffset
    dateLabelCenterOffset + 50
  end

end
