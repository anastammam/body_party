# frozen_string_literal: true

module BodyParty
  Node = Struct.new(:xpath_element) do
    attr_accessor :node

    def initialize(xpath_element)
      raise ArgumentError, "xpath_element can't be nil" if xpath_element.nil?

      self.xpath_element = xpath_element
      self.node = ox_node
    end

    def ox_node
      node = Ox::Element.new(xpath_element.name)
      node << xpath_element.value if xpath_element.value

      xpath_element.attributes.each { |attr, value| node[attr.to_sym] = value }
      node
    end
  end
end
