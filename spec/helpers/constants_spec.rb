describe "UIViewAutoresizing function" do

  # Have to bolt this method into a dummy object because we can't include
  # module methods into Bacon contexts yet
  def obj
    Object.new.extend(Patchwork)
  end

  it "generates constant from :left" do
    obj.UIViewAutoresizing(:left).should ==
      UIViewAutoresizingFlexibleLeftMargin
  end

  it "generates constant from :right" do
    obj.UIViewAutoresizing(:right).should ==
      UIViewAutoresizingFlexibleRightMargin
  end

  it "generates constant from :top" do
    obj.UIViewAutoresizing(:top).should ==
      UIViewAutoresizingFlexibleTopMargin
  end

  it "generates constant from :bottom" do
    obj.UIViewAutoresizing(:bottom).should ==
      UIViewAutoresizingFlexibleBottomMargin
  end

  it "generates constant from :width" do
    obj.UIViewAutoresizing(:width).should ==
      UIViewAutoresizingFlexibleWidth
  end

  it "generates constant from :height" do
    obj.UIViewAutoresizing(:height).should ==
      UIViewAutoresizingFlexibleHeight
  end

  it "generates all constants from :all" do
    obj.UIViewAutoresizing(:all).should ==
      (UIViewAutoresizingFlexibleHeight |
       UIViewAutoresizingFlexibleTopMargin |
       UIViewAutoresizingFlexibleBottomMargin |
       UIViewAutoresizingFlexibleLeftMargin |
       UIViewAutoresizingFlexibleRightMargin |
       UIViewAutoresizingFlexibleWidth)
  end

  it "combines constants" do
    obj.UIViewAutoresizing(:left, :right).should ==
       UIViewAutoresizingFlexibleLeftMargin |
       UIViewAutoresizingFlexibleRightMargin
  end

  it "raises an error for unknown dimension" do
    lambda {
      obj.UIViewAutoresizing(:something)
    }.should.raise(ArgumentError)
  end

end
