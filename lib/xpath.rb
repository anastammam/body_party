# /lead[@shared=true]/pii/first_name?=Aans
# /lead[@shared=true]/pii[@multiple=true]/last_name?=Tammam

module BodyParty
  XPathParser = Struct.new(:xpath) do
    def initialize(xpath)
      raise ArgumentError, "XPath shoudn't start with /" if xpath.start_with?('/')
      self.xpath = xpath
    end
    def nodes
      @nodes ||= xpath.split("/").map { |element| XPathElement.new(element) }
    end
    
    def childrens
      nodes[1..-1]
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
      return "" if !element.include?("?=")
      element.split("?=").last
    end
    
    def attributes
      return [] if element.nil?
      element.scan(/@(\w+)=([^\s\]]+)/)
    end
  end
end
