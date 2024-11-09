# frozen_string_literal: true

module BodyParty
  class XpathParser
    attr_accessor :xpath

    def initialize(xpath)
      raise ArgumentError, "XPath shoudn't start with /" if xpath.start_with?('/')
      @xpath = xpath
    end

    def nodes
      @nodes ||= xpath.split('/').map { |element| XpathElement.new(element) }
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
end
