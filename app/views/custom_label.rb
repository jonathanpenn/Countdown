class CustomLabel < UILabel
  def initWithFrame frame
    super
    self.backgroundColor = UIColor.clearColor
    self.textAlignment = UITextAlignmentCenter
    self.shadowColor = UIColor.blackColor
    self.shadowOffset = [1,1]
    self.color = UIColor.whiteColor
    self.numberOfLines = 1
    self.adjustsFontSizeToFitWidth = true
    self.font = UIFont.systemFontOfSize(18)
    self.opaque = false

    self
  end
end
