require 'active_support/core_ext/array/extract_options'

module TankGirl
  module Definition
    class Base
      attr_reader :selector_definitions

      def initialize(&block)
        @selector_definitions = []
        instance_eval(&block)
      end

      def selector(name, selector, options = {})
        @selector_definitions << Selector.new(name, selector, options)
      end
    end

    class Context < Base
      attr_reader :page_definitions

      def initialize(&block)
        @page_definitions = []
        super(&block)
      end

      def page(name, options = {}, &block)
        @page_definitions << Page.new(name, options, &block)
      end
    end

    class Page < Base
      attr_reader :name, :parent_name, :options, :block

      def initialize(args, options = {}, &block)
        if args.is_a?(Hash)
          @name, @parent_name = args.first
        else
          @name = args
        end

        @options = options
        super(&block)
      end

      def url(&block)
        @block = block
      end
    end

    class Selector
      attr_reader :name, :selector, :options, :block

      def initialize(name, selector, options = {}, &block)
        @name, @selector, @options, @block = name, selector, options, block
      end
    end
  end
end
