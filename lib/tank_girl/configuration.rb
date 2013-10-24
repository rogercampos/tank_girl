require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/module/delegation'

module TankGirl
  class Configuration
    class OptionsMatcher
      def initialize(source = {})
        @source = source
      end

      def match?(target)
        target.all? { |key, value| @source.key?(key) && @source[key] == value }
      end
    end

    class CollectionProxy
      attr_reader :collection

      def initialize(collection)
        @collection = collection
      end

      def find(name)
        @collection[name] or raise "Could not find '#{name}'"
      end

      def where(conditions = {})
        @collection.values.select { |element| OptionsMatcher.new(element.options).match?(conditions) }
      end

      def each(&block)
        @collection.values.each(&block)
      end
    end

    class Page
      attr_reader :name, :selectors, :options, :block

      def initialize(name, selectors = {}, options = {}, &block)
        @name, @selectors, @options, @block = name, selectors, options, block
      end

      def selectors
        @selectors_proxy ||= CollectionProxy.new(@selectors)
      end
    end

    class Selector
      attr_reader :name, :selector, :options, :page

      def initialize(name, selector, options = {}, page = nil)
        @name, @selector, @options, @page = name, selector, options, page
      end
    end


    def initialize(root)
      @pages = {}
      @selectors = build_selectors(root.selector_definitions)

      root.page_definitions.each do |page_def|
        @pages[page_def.name] and raise "Page already defined: '#{page_def.name}'"
        @pages[page_def.name] = build_page(page_def)
        @selectors.merge!(build_selectors(page_def.selector_definitions))
      end

      root.page_definitions.each do |page_def|
        if page_def.parent_name
          if (parent = @pages[page_def.parent_name])
            @pages[page_def.name].selectors.collection.reverse_merge!(parent.selectors.collection)
          else
            raise "Parent page '#{page_def.parent_name}' is not defined"
          end
        end
      end
    end

    def pages
      @page_proxy ||= CollectionProxy.new(@pages)
    end

    def selectors
      @selector_proxy ||= CollectionProxy.new(@selectors)
    end

    protected

    def build_page(page_def)
      Page.new(page_def.name, @selectors.merge(build_selectors(page_def.selector_definitions)), &page_def.block)
    end

    def build_selector(definition)
      Selector.new(definition.name, definition.selector, definition.options)
    end

    def build_selectors(selector_definitions)
      selector_definitions.each_with_object({}) { |selector_def, c| c[selector_def.name] = build_selector(selector_def) }
    end
  end
end
