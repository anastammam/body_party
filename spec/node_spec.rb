# frozen_string_literal: true

require 'spec_helper'

describe BodyParty::Node do
  context 'Ox Node' do
    let(:node_with_attributes) { described_class.new(BodyParty::XPathElement.new('department[@id=1]')) }
    let(:node_with_attributes_and_value) { described_class.new(BodyParty::XPathElement.new('department[@id=1]?=IT')) }
    let(:node) { described_class.new(BodyParty::XPathElement.new('department')) }

    it 'should respond to #node with Ox::Element' do
      expect(node.node).to be_instance_of(Ox::Element)
    end

    it 'should respond to #node with ' do
      expect(node.node).to be_instance_of(Ox::Element)
    end

    it 'should create node with attributes' do
      expect(node_with_attributes.node.attributes).to match_array([[:id, '1']])
    end

    it 'should create node with attributes and value' do
      expect(node_with_attributes_and_value.node.value).to eq('department')
    end

    it 'should create node with attributes and name' do
      expect(node_with_attributes_and_value.node.nodes.first).to eq('IT')
    end
  end
end
