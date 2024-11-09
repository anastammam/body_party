# frozen_string_literal: true

require 'spec_helper'

describe BodyParty::XpathParser do
  let(:xpath) { 'food/order[@delivered=false @paid=false]/name?=Pasta' }
  let(:xpath_parser) { described_class.new(xpath) }

  it 'should return correct root element' do
    expect(xpath_parser.root.name).to eq(BodyParty::XpathElement.new('food').name)
  end

  it 'should return correct root name' do
    expect(xpath_parser.root.name).to eq('food')
  end

  it 'should return correct value' do
    expect(xpath_parser.value).to eq('Pasta')
  end

  it 'should return correct childrens elements' do
    xpath_parser = described_class.new(xpath)
    childrens = [
      BodyParty::XpathElement.new('order[@delivered=false @paid=false]'),
      BodyParty::XpathElement.new('name?=Pasta')

    ]
    expect(xpath_parser.childrens[0]).to have_attributes(element: "order[@delivered=false @paid=false]")
    expect(xpath_parser.childrens[1]).to have_attributes(element: "name?=Pasta")
  end
end

describe BodyParty::XpathElement do
  context 'attributes' do
    it 'should return attributes of the element' do
      xpath_element = described_class.new('user[@subscribed=true @plan=monthly]')
      expect(xpath_element.attributes).to match_array([%w[subscribed true], %w[plan monthly]])
    end
  end

  context 'value' do
    it 'should return empty xpath value' do
      xpath_element = described_class.new('user[@subscribed=true @plan=monthly]')
      expect(xpath_element.value).to eq('')
    end

    it 'should return correct xpath value' do
      xpath_element = described_class.new('username[@subscribed=true @plan=monthly]?=anas')
      expect(xpath_element.value).to eq('anas')
    end
  end
end
