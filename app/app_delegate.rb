class AppDelegate
  attr_accessor :window
  attr_accessor :navViewController
  attr_accessor :collection

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    setupVisuals

    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    self.collection = Config.countdownCollection

    controller = CountdownCollectionTableViewController.alloc.init
    controller.collection = collection

    self.navViewController = UINavigationController.alloc.initWithRootViewController(controller)

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
      color = UIColor.colorWithRed(0.217, green:0.231, blue:0.182, alpha:1.000)
      bar.tintColor = color
    end

    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleBlackTranslucent,
                                                      animated: true)
  end

end
