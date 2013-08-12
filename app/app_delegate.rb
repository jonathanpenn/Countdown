class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    setupVisuals

    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    collection = Config.countdownCollection

    controller = CountdownCollectionTableViewController.alloc.init
    controller.collection = collection

    navViewController = UINavigationController.alloc.initWithRootViewController(controller)

    selectedIndex = Config.selectedCountdownIndex
    if selectedIndex
      controller.openCountdownAtIndex(selectedIndex)
    end

    window.rootViewController = navViewController

    window.makeKeyAndVisible

    true
  end


  private

  def setupVisuals
    UINavigationBar.appearance.tap do |bar|
      color = UIColor.colorWithRed(0, green:0, blue:0, alpha:3.000)
      bar.tintColor = color
    end

    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleBlackOpaque,
                                                      animated: false)
  end

end
