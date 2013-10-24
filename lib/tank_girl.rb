module TankGirl
  autoload :Configuration, "tank_girl/configuration"
  autoload :SelectorDefinition, "tank_girl/selector_definition"
  autoload :Definition, "tank_girl/definition"
  autoload :HeavyMachinery, "tank_girl/heavy_machinery"
  autoload :Helpers, "tank_girl/helpers"
  autoload :PageDefinition, "tank_girl/page_definition"
  autoload :VERSION, "tank_girl/version"

  class << self
    def configuration
      @configuration or raise "TankGirl not configured"
    end

    def configure(&block)
      @configuration = Configuration.new(Definition::Context.new(&block))
    end
  end
end
