class CountdownEditorViewController < UITableViewController
  include Patchwork

  attr_accessor :countdown

  attr_reader :datePickerCell
  attr_reader :nameField, :nameFieldCell

  #
  # Creates a new countdown editor and wraps it in a navigation controller
  # ready for modal display.
  #
  # Register the done or cancel callbacks that take the editor as a
  # parameter.
  #
  def self.withNavigationForCountdown countdown, onDone: onDone, onCancel: onCancel
    editor = self.alloc.initWithStyle(UITableViewStyleGrouped)
    editor.countdown = countdown

    editor.onDone(onDone).onCancel(onCancel)

    controller = UINavigationController.alloc.initWithRootViewController(editor)
    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
      controller.modalPresentationStyle = UIModalPresentationFormSheet
    end

    controller
  end

  def onDone block
    @onDone = block
    self
  end

  def onCancel block
    @onCancel = block
    self
  end


  #
  # View Controller Callbacks
  #

  def viewDidLoad
    super
    self.title = "Countdown"
    tableView.backgroundColor = UIColor.lightGrayColor
    setupDatePicker
    setupNameField
    setupNavBar
  end

  def viewWillAppear animated
    super
    @nameField.becomeFirstResponder
  end

  def shouldAutorotateToInterfaceOrientation orientation
    true
  end


  #
  # Date Picking
  #

  def showDatePickerActionSheet
    actionSheet = DatePickerActionSheet.sheet
    actionSheet.date = countdown.endDate.toTime

    actionSheet.onDone(-> sheet {
      sheet.dismissSheet
      deselecteDateRow
    }).onChange(-> sheet {
      countdown.endDate = CountdownDate(sheet.date)
      datePickerCell.textLabel.text = countdown.endDate.to_s
    })

    actionSheet.showInView(self.view)
  end

  def deselecteDateRow
    tableView.deselectRowAtIndexPath(
      tableView.indexPathForSelectedRow,
      animated: true)
  end


  #
  # Table View Callbacks
  #

  def numberOfSectionsInTableView tableView
    2
  end

  def tableView tableView, numberOfRowsInSection: section
    1
  end

  def tableView tableView, cellForRowAtIndexPath: path
    case path.section
    when 0
      nameFieldCell
    when 1
      datePickerCell
    end
  end

  def tableView tableView, willSelectRowAtIndexPath: path
    if path.section == 0
      nil
    else
      path
    end
  end

  def tableView tableView, didSelectRowAtIndexPath: path
    if path.section == 1
      @nameField.resignFirstResponder
      showDatePickerActionSheet
    end
  end



  #
  # Text Input Delegate callbacks
  #

  def textFieldShouldReturn textField
    textField.resignFirstResponder
    tableView.selectRowAtIndexPath(
      NSIndexPath.indexPathForRow(0, inSection: 1),
      animated: true,
      scrollPosition: UITableViewScrollPositionNone)
    showDatePickerActionSheet
    false
  end


  private

  #
  # Setup
  #

  def setupDatePicker
    @datePickerCell = UITableViewCell.alloc.init
    datePickerCell.textLabel.tap do |label|
      label.text = countdown.endDate.to_s
      label.textAlignment = UITextAlignmentLeft
    end
    datePickerCell.selectionStyle = UITableViewCellSelectionStyleGray
  end

  def setupNameField
    @nameFieldCell = UITableViewCell.alloc.init
    frame = UIEdgeInsetsInsetRect(nameFieldCell.bounds, [10,20,10,20])
    @nameField = UITextField.alloc.initWithFrame(frame)

    nameField.text = countdown.name
    nameField.autoresizingMask = UIViewAutoresizing(:all)
    nameField.returnKeyType = UIReturnKeyNext
    nameField.textAlignment = UITextAlignmentLeft
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing
    nameField.placeholder = "Name"
    nameField.delegate = self

    nameFieldCell.addSubview nameField
  end

  def setupNavBar
    button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemDone,
      target: self,
      action: 'donePressed')
    navigationItem.setRightBarButtonItem button

    button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemCancel,
      target: self,
      action: 'cancelPressed')
    navigationItem.setLeftBarButtonItem button
  end


  # Callbacks for nav bar buttons

  def donePressed
    countdown.name = nameField.text
    @onDone.call(self) if @onDone
  end

  def cancelPressed
    @onCancel.call(self) if @onCancel
  end

end
