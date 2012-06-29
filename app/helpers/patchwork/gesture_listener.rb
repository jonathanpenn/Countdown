module Patchwork

  module GestureListener

    class GestureHandler
      def initialize callback
        @callback = callback
      end

      def invoke recognizer
        @callback.call(recognizer)
      end
    end

    def onSwipe &block
      handler = GestureHandler.new(block)
      gesture = UISwipeGestureRecognizer.alloc.initWithTarget(
        handler,
        action: 'invoke:')
      gesture.extend(AssociatedObjects)
      gesture.associations["GestureListenerOnSwipe"] = handler
      gesture.direction = UISwipeGestureRecognizerDirectionRight
      addGestureRecognizer gesture
      gesture
    end

    def onTap &block
      handler = GestureHandler.new(block)
      gesture = UITapGestureRecognizer.alloc.initWithTarget(
        handler,
        action: 'invoke:')
      gesture.extend(AssociatedObjects)
      gesture.associations["GestureListenerOnTap"] = handler
      addGestureRecognizer gesture
      gesture
    end

    def onDoubleTap &block
      handler = GestureHandler.new(block)
      gesture = UITapGestureRecognizer.alloc.initWithTarget(
        handler,
        action: 'invoke:')
      gesture.numberOfTapsRequired = 2
      gesture.extend(AssociatedObjects)
      gesture.associations["GestureListenerOnDoubleTap"] = handler
      addGestureRecognizer gesture
      gesture
    end

  end

end
