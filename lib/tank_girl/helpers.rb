module TankGirl
  module Helpers
    def tank_girl
      @heavy_machinery ||= begin
        TankGirl::HeavyMachinery.new(TankGirl.configuration)
      end
    end
  end
end
