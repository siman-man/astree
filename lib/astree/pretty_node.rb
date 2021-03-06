class ASTree
  class PrettyNode
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def stringify_element(index)
      label = label_name(index)

      if label.nil?
        raise "Unexpected index [#{index}] - #{node.inspect}."
      end

      "%s (%s)\n" % [colorize_element(element_value(index)), label]
    end

    def element_value(index)
      node.children[index]
    end

    def label_name(index)
      raise NotImplementedError
    end

    private

    def colorize_element(value)
      case value
      when String
        value.inspect.colorize(:red)
      when Symbol
        value.inspect.colorize(:yellow)
      when NilClass
        value.inspect.colorize(:cyan)
      else
        value.inspect
      end
    end
  end
end
