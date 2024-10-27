module BodyParty
  class Document
    attr_accessor :xpaths, :doc

    def initialize(**args)
      @xpaths = args.fetch(:xpaths)
      @doc = build_doc
    end

    def generate!
      xpaths.each do |xpath|
        xpath_parser = ::BodyParty::XPathParser.new(xpath)
        node = create_node_from_xpath(xpath_parser)
        doc << node unless doc.nodes.any? { |n| node.equal?(n) }
      end
      ox = Ox.dump(doc)
    end
 
    def create_node_from_xpath(xpath)
      root_node = find_or_create_root_node(xpath.root)

      create_child_nodes(root_node, xpath.childrens)
      root_node
    end
    
    # Find last possible parent within the childrens
    def find_last_child(parent, childrens)
      return parent if childrens.empty?
      
      if childrens.count == 1 # Last child will the one to be created
        return parent
      end
      
      child_element = childrens.shift


      child = locate_child(parent, child_element)

      if child.nil?
        childrens.unshift(child_element)
        return parent
      end

      find_last_child(child, childrens)
    end

    def create_child_nodes(root, childrens)
      return root if childrens.empty?

      root = find_last_child(root, childrens)

      if childrens.count <= 1
        return root if childrens.empty?
        last_node_name = childrens.shift
        child = create_node(last_node_name)
        root << child
        return root
      end

      child_name = childrens.shift
      child = create_node(child_name)

      root << create_child_nodes(child, childrens)
    end
    
    def locate_child(parent, child)

      child_attributes = child.attributes
      child_name = child.name

      unless child_attributes.empty?
        formatted_child_attributes =
          child_attributes.map { |attr, value| "#{child_name}[@#{attr}=#{value}]" }
        match = formatted_child_attributes.all? do |attr|
          child = parent.locate(attr).last
          return nil if child.nil?
          return child if child&.attributes&.transform_keys(&:to_s).to_a == child_attributes
        end
      else
        return parent.locate(child_name).first
      end
    end

    def find_or_create_root_node(xpath)
      locate_child(doc, xpath) || create_node(xpath)
    end
    
    def create_node(element)
      BodyParty::Node.new(element).node
    end

    def self.generate(**args)
      xpaths = args.fetch(:xpaths)
      new(xpaths:).generate!
    end

    def build_doc
      doc = Ox::Document.new
      instruct = Ox::Instruct.new(:xml)

      instruct[:version] = '1.0'
      instruct[:encoding] = 'UTF-8'
      doc << instruct
      doc
    end
  end
end
