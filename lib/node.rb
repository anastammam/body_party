module BodyParty
  Node = Struct.new(:xpath_element) do
    attr_accessor :node

    def initialize(xpath_element)
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
