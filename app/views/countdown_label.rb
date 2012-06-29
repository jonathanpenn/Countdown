class CountdownLabel < UILabel
  attr_accessor :colorScheme

  def initWithFrame frame
    super
    self.backgroundColor = UIColor.blackColor
    self.textAlignment = UITextAlignmentCenter
    self.color = UIColor.whiteColor
    self.shadowColor = UIColor.darkGrayColor
    self.shadowOffset = [1,1]
    self.numberOfLines = 1
    self.adjustsFontSizeToFitWidth = true
    self.font = UIFont.boldSystemFontOfSize(60)
    self
  end

end
