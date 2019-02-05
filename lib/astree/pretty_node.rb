class ASTree
  class PrettyNode
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def stringify_element(index)
      "%p %s\n" % [element_value(index), label_name(index)]
    end

    def element_value(index)
      node.children[index]
    end

    def label_name(index)
      raise NotImplementedError
    end
  end
end
