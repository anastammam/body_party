# frozen_string_literal: true

module BodyParty
  XPathParser = Struct.new(:xpath) do
    def initialize(xpath)
      raise ArgumentError, "XPath shoudn't start with /" if xpath.start_with?('/')

      self.xpath = xpath
    end

    def nodes
      @nodes ||= xpath.split('/').map { |element| XPathElement.new(element) }
    end

    def childrens
      nodes[1..]
    end

    def root
      nodes.first
    end

    # Each Xpath has one value
    def value
      nodes.last.value
    end
  end

  XPathElement = Struct.new(:element) do
    def name
      element.split(/\[|\?=/).first
    end

    def value
      return '' unless element.include?('?=')

      element.split('?=').last
    end

    def attributes
      return [] if element.nil?

      element.scan(/@(\w+)=([^\s\]]+)/)
    end
  end
end
