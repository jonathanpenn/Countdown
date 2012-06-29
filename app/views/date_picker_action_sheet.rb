class DatePickerActionSheet < UIActionSheet
  attr_reader :pickerView

  def date
    pickerView.date
  end

  def date= newDate
    pickerView.date = newDate
  end

  def self.sheet
    sheet = self.alloc.initWithTitle(
      nil,
      delegate:self,
      cancelButtonTitle:nil,
      destructiveButtonTitle:nil,
      otherButtonTitles:nil)
    sheet.send 'setup'
    sheet
  end

  def dismissSheet
    dismissWithClickedButtonIndex(0, animated: true)
  end

  def onDone block
    @onDone = block
    self
  end

  def onChange block
    @onChange = block
    self
  end

  def showInView view
    super
    sizeToFit
    self.bounds = [[0,0],[320,500]]
  end


  private

  def setup
    @pickerView = UIDatePicker.alloc.initWithFrame([[0,44],[0,0]])
    pickerView.datePickerMode = UIDatePickerModeDate
    pickerView.minimumDate = Time.now
    pickerView.maximumDate = Time.now + (2*365*24*60*60)
    pickerView.sizeToFit
    pickerView.addTarget(
      self,
      action: 'dateChanged',
      forControlEvents: UIControlEventValueChanged)

    spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace,
      target: nil, action: nil)
    doneBtn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemDone,
      target: self,
      action: 'doneDatePicking')

    toolbar = UIToolbar.alloc.initWithFrame([[0,0],[320,0]])
    toolbar.barStyle = UIBarStyleBlackOpaque
    toolbar.items = [spacer, doneBtn]
    toolbar.sizeToFit

    addSubview(pickerView)
    addSubview(toolbar)
  end

  def dateChanged
    @onChange.call(self) if @onChange
  end

  def doneDatePicking
    @onDone.call(self) if @onDone
  end

end
