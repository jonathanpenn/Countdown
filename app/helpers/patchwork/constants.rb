module Patchwork

  def UIViewAutoresizing *masks
    values = masks.map do |sym|
      case sym
      when :left
        UIViewAutoresizingFlexibleLeftMargin
      when :right
        UIViewAutoresizingFlexibleRightMargin
      when :top
        UIViewAutoresizingFlexibleTopMargin
      when :bottom
        UIViewAutoresizingFlexibleBottomMargin
      when :width
        UIViewAutoresizingFlexibleWidth
      when :height
        UIViewAutoresizingFlexibleHeight
      when :all
        UIViewAutoresizing(:left, :right, :top, :bottom, :width, :height)
      else
        raise ArgumentError.new("Unknown UIViewAutoresizing mask: :#{sym}")
      end
    end

    values.inject(0) do |result, value|
      result | value
    end
  end

end
