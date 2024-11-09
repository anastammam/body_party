module BodyParty
  class XpathElement
    attr_accessor :element, :value

    def initialize(element)
      @element = element
    end
    def name
      element.split(/\[|\?=/).first
    end

    def value
      return '' unless element.include?('?=')

      @value ||= element.split('?=').last
    end

    def attributes
      return [] if element.nil?

      element.scan(/@(\w+)=([^\s\]]+)/)
    end
  end
end
