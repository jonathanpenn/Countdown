class SwipeToGoBackInstructionsLabel < UILabel
  include Patchwork

  attr_reader :animatedArrowView

  def initWithFrame frame
    if super
      setupSelf
      setupAnimationView
    end

    self
  end

  def animate
    return if @animating

    @animating = true

    self.alpha = 0
    animatedArrowView.alpha = 0

    UIView.animateWithDuration(0.3, animations: lambda {
      self.alpha = 0.6
    }, completion: lambda { |finished|
      moveArrow
      performSelector 'hide', withObject: nil, afterDelay: 2
    })
  end

  def moveArrow
    animatedArrowView.alpha = 0
    animatedArrowView.center = [0, size.height/3]

    UIView.animateWithDuration(0.5, animations: lambda {
      animatedArrowView.alpha = 1
    }, completion: lambda { |finished|
      UIView.animateWithDuration(0.5, animations: lambda {
        animatedArrowView.alpha = 0
      })
    })

    UIView.animateWithDuration(1, animations: lambda {
      animatedArrowView.center = [size.width, size.height/3]
    })
  end

  def hide
    UIView.animateWithDuration(1, animations: lambda {
      self.alpha = 0
    }, completion: lambda { |finished|
      @animating = false
    })
  end


  private

  def setupSelf
    self.autoresizingMask = UIViewAutoresizing(:all)
    self.textAlignment = UITextAlignmentCenter
    self.font = UIFont.systemFontOfSize(14)
    self.adjustsFontSizeToFitWidth = true
    self.color = UIColor.whiteColor
    self.backgroundColor = UIColor.clearColor
    self.opaque = false
    self.text = "Swipe to go back to list"
    self.numberOfLines = 1
    self.alpha = 0

    sizeToFit
  end

  def setupAnimationView
    @animatedArrowView = UILabel.alloc.init
    animatedArrowView.backgroundColor = UIColor.clearColor
    animatedArrowView.color = UIColor.whiteColor
    animatedArrowView.opaque = false
    animatedArrowView.text = "\u21E2"
    animatedArrowView.font = UIFont.boldSystemFontOfSize(25)
    animatedArrowView.sizeToFit

    addSubview(animatedArrowView)
  end

end
