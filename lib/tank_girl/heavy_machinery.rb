require 'active_support/core_ext/module/delegation'

module TankGirl
  class HeavyMachinery
    attr_reader :configuration, :references
    delegate :pages, :selectors, to: :configuration

    def initialize(configuration = TankGirl.configuration)
      @references = {}
      @configuration = configuration
    end

    def set(key, value)
      @references[key] = value
    end

    def get(key)
      @references[key] or raise "#{key} not set"
    end
  end
end
