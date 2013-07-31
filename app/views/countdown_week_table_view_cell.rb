class CountdownWeekTableViewCell < UITableViewCell
  attr_reader :weekDots, :monthLabel
  attr_accessor :weekStartDate, :calculator, :isFirstCell

  def self.cell
    cell = alloc.initWithStyle(UITableViewCellStyleDefault,
                               reuseIdentifier: name)
    cell.layer.shouldRasterize = true
    cell.layer.rasterizationScale = UIScreen.mainScreen.scale
    cell.backgroundColor = UIColor.blackColor
    cell.setup
    cell
  end

  def weekStartDate= date
    @weekStartDate = date

    if isFirstCell or isFirstWeekOfMonth
      @monthLabel.text = monthName
    else
      @monthLabel.text = nil
    end

    @weekDots.each_with_index do |dot, i|
      dotDay = weekStartDate.nextDay(i)
      if dotDay == calculator.startDate
        dot.backgroundColor = UIColor.redColor
        dot.color = UIColor.blackColor
      elsif dotDay >= calculator.startDate && calculator.includesDate?(dotDay)
        dot.color = UIColor.redColor
        dot.backgroundColor = UIColor.blackColor
      else
        dot.color = UIColor.grayColor
        dot.backgroundColor = UIColor.blackColor
      end

      dot.text = "%d" % [dotDay.toTime.day]
    end
  end

  def weekEndDate
    weekStartDate.nextDay(6)
  end

  def isFirstWeekOfMonth
    weekEndDate.toTime.day <= 7
  end

  def monthName
    weekEndDate.toTime.strftime("%b").upcase
  end

  def setup
    @monthLabel = UILabel.alloc.init
    addSubview @monthLabel
    @monthLabel.font = UIFont.systemFontOfSize 14
    @monthLabel.color = UIColor.whiteColor
    @monthLabel.backgroundColor = UIColor.blackColor

    @weekDots = []
    7.times do |i|
      dot = UILabel.alloc.initWithFrame [[0,0],[20,20]]
      dot.textAlignment = UITextAlignmentCenter
      dot.backgroundColor = UIColor.blackColor
      dot.adjustsFontSizeToFitWidth
      dot.layer.masksToBounds = true
      dot.layer.cornerRadius = 5
      dot.font = UIFont.systemFontOfSize 14
      addSubview dot
      @weekDots << dot
    end
  end

  def layoutSubviews
    super

    width = bounds.size.width
    height = bounds.size.height

    yCenter = (height / 2).floor
    labelWidth = (width * 0.3).floor
    dotsWidth = (width * 0.65).floor
    dotSpacing = (dotsWidth / @weekDots.length).floor

    @monthLabel.sizeToFit
    @monthLabel.center = [(labelWidth / 2).floor, yCenter]

    @weekDots.each_with_index do |dot, i|
      x = labelWidth + i * dotSpacing
      dot.center = [x, yCenter]
    end
  end

end
