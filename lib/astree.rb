require 'astree/version'
require 'colorize'

class ASTree
  SPACE_SIZE = 7
  T_LINE = '├─────'.freeze
  I_LINE = '│'.freeze
  L_LINE = '└─────'.freeze

  def self.parse(source_code)
    new(source_code)
  end

  def initialize(source_code)
    ast = RubyVM::AbstractSyntaxTree.parse(source_code)
    @buffer = traverse(ast)
  end

  def to_s
    @buffer
  end

  private

  def traverse(node, parent: nil)
    return stringify_element(node) unless node.instance_of?(RubyVM::AbstractSyntaxTree::Node)

    buffer = stringify_node(node)

    children = node.children

    until children.empty?
      child = children.shift
      last_element = children.empty?
      child_buffer = traverse(child, parent: node).lines
      buffer << draw_line(token: child_buffer.shift, last_element: last_element)

      child_buffer.each do |line|
        buffer << draw_space(last_element: last_element) + line
      end
    end

    buffer
  end

  def stringify_element(element)
    str = element.inspect
    (element.is_a?(Symbol) ? str.colorize(:magenta) : str) + "\n"
  end

  def stringify_node(node)
    "<%s>\n" % [node.type.to_s.colorize(:green)]
  end

  def draw_space(last_element:)
    last_element ? ' ' * SPACE_SIZE : I_LINE + ' ' * (SPACE_SIZE - 1)
  end

  def draw_line(token:, last_element:)
    '%s %s' % [last_element ? L_LINE : T_LINE, token]
  end
end
