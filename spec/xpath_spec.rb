require 'spec_helper'


describe BodyParty::XPathParser do
  let(:xpath) { "food/order[@delivered=false @paid=false]/name?=Pasta" }
  let(:xpath_parser) { described_class.new(xpath) }

  it "should return correct root element" do
    expect(xpath_parser.root).to eq(BodyParty::XPathElement.new("food"))
  end

  it "should return correct root name" do
    expect(xpath_parser.root.name).to eq("food")
  end

  it "should return correct value" do
    expect(xpath_parser.value).to eq("Pasta")
  end

  it "should return correct childrens elements" do
    xpath_parser = described_class.new(xpath)
    childrens = [
      BodyParty::XPathElement.new("order[@delivered=false @paid=false]"),
      BodyParty::XPathElement.new("name?=Pasta"),

    ]
    expect(xpath_parser.childrens).to match_array(childrens)
  end
end

describe BodyParty::XPathElement do

  context "attributes" do
    it "should return attributes of the element" do
      xpath_element = described_class.new("user[@subscribed=true @plan=monthly]")
      expect(xpath_element.attributes).to match_array([["subscribed", "true"], ["plan", "monthly"]])
    end
  end

  context "value" do
    it "should return empty xpath value" do
      xpath_element = described_class.new("user[@subscribed=true @plan=monthly]")
      expect(xpath_element.value).to eq("")
    end
    
    it "should return correct xpath value" do
      xpath_element = described_class.new("username[@subscribed=true @plan=monthly]?=anas")
      expect(xpath_element.value).to eq("anas")
    end
  end
end
