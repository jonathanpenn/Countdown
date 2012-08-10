class CountdownViewController < UITableViewController
  include Patchwork

  attr_accessor :countdown
  attr_reader :countdownCalculator
  attr_reader :instructionsView

  def self.controller
    self.alloc.init
  end

  def update
    countdownCalculator.startDate = CountdownDate.now

    if countdownCalculator.daysLeft == 0
      tableView.showsVerticalScrollIndicator = false
      removeTableViewFooter
    else
      tableView.showsVerticalScrollIndicator = true
      addTableViewFooter
    end

    if countdownCalculator.pastDate?(CountdownDate.now)
      navigationController.popViewControllerAnimated(true)
    else
      tableView.reloadData
      updateFromTableViewScrollPosition
    end
  end

  def countdown= newCountdown
    @countdown = newCountdown
    update
  end

  def countdownCalculator
    @countdownCalculator ||= CountdownCalculator.newWithStart(
      CountdownDate.now,
      end: countdown.endDate)
  end


  #
  # View Controller Callbacks
  #

  def viewDidLoad
    super

    setupTableView
  end

  def viewWillAppear animated
    super
    navigationController.setNavigationBarHidden(true, animated: animated)
    @layoutShouldReloadTable = true
  end

  def viewDidAppear animated
    super
    NSNotificationCenter.defaultCenter.addObserver(
      self,
      selector: 'update',
      name: UIApplicationDidBecomeActiveNotification,
      object: nil)

    animateInstructionsViewIfItHasBeenAWhile
  end

  def viewWillDisappear animated
    super
    NSNotificationCenter.defaultCenter.removeObserver self
  end

  def viewWillLayoutSubviews
    super

    # A hack to solve the problem where the navigation bar was crimping the
    # table cell height
    if @layoutShouldReloadTable
      @layoutShouldReloadTable = nil
      tableView.reloadData
    end
  end

  def shouldAutorotateToInterfaceOrientation orientation
    true
  end

  def willRotateToInterfaceOrientation(orientation, duration: duration)
    super
    update
  end


  #
  # Table View Callbacks
  #

  def tableView tableView, cellForRowAtIndexPath: path
    row = path.row

    if row == 0
      cell = tableView.dequeueReusableCellWithIdentifier(CountdownTableViewCell.name)
      cell = CountdownTableViewCell.cell unless cell
      cell.distance = 1

      daysLeft = countdownCalculator.daysLeft

      cell.countdown = countdown
      cell.countdownCalculator = countdownCalculator.calculatorWithDaysBeforeEndTime(daysLeft)
    else
      cell = tableView.dequeueReusableCellWithIdentifier(CountdownWeekTableViewCell.name)
      cell = CountdownWeekTableViewCell.cell unless cell
      cell.isFirstCell = (row == 1)
      cell.calculator = countdownCalculator

      weekStartDate = countdownCalculator.startDateForWeekNum(row-1)
      cell.weekStartDate = weekStartDate
    end

    cell
  end

  def tableView tableView, numberOfRowsInSection: section
    if countdownCalculator.daysLeft == 0
      1
    else
      countdownCalculator.weeksSpanned + 1
    end
  end

  def tableView tableView, willSelectRowAtIndexPath: path
    nil
  end

  def tableView tableView, heightForRowAtIndexPath: path
    if path.row == 0 then tableView.bounds.size.height else 45 end
  end


  #
  # Scroll View Callbacks
  #

  def scrollViewDidScroll scrollView
    updateFromTableViewScrollPosition
  end

  def scrollViewWillBeginDragging scrollView
    scrollView.pagingEnabled = false
  end

  def scrollViewWillEndDragging scrollView,
    withVelocity: velocity,
    targetContentOffset: offsetPtr

    # When the user lets go, we want to snap back to the top if they are
    # "almost" there. We're using the built in paging to pull that off.

    offset = offsetPtr[0]
    if (offset.y - scrollView.bounds.size.height / 3) < 0
      # Snap when near the top
      offsetPtr[0] = [0,0]
      scrollView.pagingEnabled = true
    end
  end



  private

  def distance
    # Used to calculate a distance ratio for parallax scrolling
    point = tableView.contentOffset
    height = tableView.bounds.size.height
    threshold = (height / 2).floor
    [point.y, threshold].min / threshold
  end

  def updateFromTableViewScrollPosition
    # Tells the top cell what the distance ratio is for parallax scrolling
    point = tableView.contentOffset
    height = tableView.bounds.size.height

    if point.y < height
      # Then the first cell is still visible
      topCell = cellAtRow(0)
      topCell.distance = 1-distance
    end
  end

  def cellAtRow row
    path = NSIndexPath.indexPathForRow(row, inSection: 0)
    tableView.cellForRowAtIndexPath(path)
  end

  def editThisCountdown
    controller = CountdownEditorViewController.withNavigationForCountdown(
      countdown,
      onDone: -> editor {
        countdown.collection.save
        tableView.contentOffset = [0,0]
        dismissModalViewControllerAnimated(true)
        @countdownCalculator = nil
        update
      },
      onCancel: -> editor {
        dismissModalViewControllerAnimated(true)
      }
    )
    presentModalViewController(controller, animated: true)
  end


  #
  # Setup
  #

  def setupTableView
    t = tableView
    t.allowsSelection = false
    t.backgroundColor = UIColor.blackColor
    t.separatorStyle = UITableViewCellSeparatorStyleNone
    t.indicatorStyle = UIScrollViewIndicatorStyleWhite

    t.extend(GestureListener)
    t.onSwipe do
      navigationController.popViewControllerAnimated true
    end

    t.onDoubleTap { editThisCountdown }

    @instructionsView = SwipeToGoBackInstructionsLabel.alloc.init
    instructionsView.frame = [[0,0],[view.size.width, 120]]

    tableView.addSubview(instructionsView)
  end

  def addTableViewFooter
    tableView.tableFooterView = UIView.alloc.initWithFrame(
      [[0,0],[320,tableView.bounds.size.height/2]])
    tableView.tableFooterView.backgroundColor = UIColor.blackColor
  end

  def removeTableViewFooter
    tableView.tableFooterView = nil
  end


  #
  # Instruction Animation
  #

  def animateInstructionsViewIfItHasBeenAWhile
    elapsedSeconds = Time.now - Config.whenLastShownSwipeInstructions
    if elapsedSeconds > 60 # at least a minute
      Config.whenLastShownSwipeInstructions = Time.now
      instructionsView.animate
    end
  end

end
