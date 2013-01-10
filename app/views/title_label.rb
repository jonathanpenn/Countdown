class TitleLabel < UILabel
  def initWithFrame frame
    return nil unless super
    self.backgroundColor = UIColor.clearColor
    self.opaque = false
    self.textAlignment = UITextAlignmentCenter
    self.shadowColor = UIColor.blackColor
    self.shadowOffset = [1,1]
    self.color = UIColor.whiteColor
    self.numberOfLines = 1
    self.adjustsFontSizeToFitWidth = true
    self.font = UIFont.systemFontOfSize(20)
    self
  end
end
