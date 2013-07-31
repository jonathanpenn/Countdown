class CountdownCollectionTableViewController < UITableViewController
  attr_accessor :collection


  #
  # Public methods
  #

  def openCountdownAtIndex index
    Config.selectedCountdownIndex = index
    countdown = collection[index]
    controller = CountdownViewController.controller
    controller.countdown = countdown
    navigationController.pushViewController(controller,
                                            animated: true)
  end


  #
  # View Controller Callbacks
  #

  def viewDidLoad
    super
    self.title = "Countdowns"
    setupNavButtons
    setupTableView

    view.backgroundColor = UIColor.whiteColor
  end

  def viewWillAppear animated
    super
    navigationController.setNavigationBarHidden(false, animated: animated)
    tableView.reloadData
  end

  def viewDidAppear animated
    super
    Config.selectedCountdownIndex = nil
  end

  def shouldAutorotateToInterfaceOrientation orientation
    true
  end


  #
  # Table View Callbacks
  #

  def tableView tableView, numberOfRowsInSection: section
    collection.length
  end

  def tableView tableView, cellForRowAtIndexPath: path
    countdown = collection[path.row]

    cell = CountdownCollectionTableViewCell.cell
    cell.countdown = countdown

    cell
  end

  def tableView tableView, didSelectRowAtIndexPath: path
    countdown = collection[path.row]
    if tableView.isEditing
      editCountdown(countdown, completion: -> editor {
        collection.save
        setEditing(false, animated: false)
        tableView.reloadData
      })
    else
      if countdown.endDate >= CountdownDate.now
        openCountdown(countdown)
      end
    end
    tableView.deselectRowAtIndexPath(path, animated: true)
  end

  def tableView tableView, commitEditingStyle: style, forRowAtIndexPath: path
    if style == UITableViewCellEditingStyleDelete
      collection.deleteAt(path.row)
      collection.save
      tableView.deleteRowsAtIndexPaths([path],
        withRowAnimation: UITableViewRowAnimationFade)
    end
  end


  private

  #
  # Setup
  #

  def setupNavButtons
    navigationItem.leftBarButtonItem = editButtonItem
    addButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAdd,
      target: self,
      action: 'addButtonPressed')
    navigationItem.rightBarButtonItem = addButtonItem
  end

  def setupTableView
    tableView.allowsSelectionDuringEditing = true
    tableView.rowHeight = 50
  end


  #
  # Managing the countdown list
  #

  def addButtonPressed
    editCountdown(Countdown.new, completion:-> countdown {
      collection.insert(countdown)
      collection.save
      openCountdown(countdown)
      tableView.reloadData
    })
  end

  def editCountdown countdown, completion: block
    controller = CountdownEditorViewController.withNavigationForCountdown(
      countdown,
      onDone: -> editor {
        block.call(countdown)
        dismissModalViewControllerAnimated(true)
      },
      onCancel: -> editor {
        dismissModalViewControllerAnimated(true)
      })
    presentModalViewController(controller, animated: true)
  end

  def openCountdown countdown
    index = collection.index(countdown)
    openCountdownAtIndex index
  end

end

