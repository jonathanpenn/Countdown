module Patchwork

  module GestureListener

    class GestureHandler
      # Uncomment this method to demonstrate that we are not leaking
      #def dealloc
      #  puts "Dealloc #{self.class}"
      #  super
      #end

      attr_accessor :gesture

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
      gesture.direction = UISwipeGestureRecognizerDirectionRight
      addGestureRecognizer gesture
      handler.gesture = gesture
      handler
    end

    def onDoubleTap &block
      handler = GestureHandler.new(block)
      gesture = UITapGestureRecognizer.alloc.initWithTarget(
        handler,
        action: 'invoke:')
      gesture.numberOfTapsRequired = 2
      addGestureRecognizer gesture
      handler.gesture = gesture
      handler
    end

  end

end

