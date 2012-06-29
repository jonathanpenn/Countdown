module Patchwork

  module AssociatedObjects
    attr_reader :associations

    def associations
      @associations ||= Hash.new
    end
  end

end
