require 'colorize'

Dir[File.join(__dir__, '**/*.rb')].each do |f|
  require f
end

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

  def traverse(node)
    buffer = stringify_node(node)

    children = node.children
    children_count = children.size

    children_count.times do |index|
      child = children[index]
      last_element = children_count == index + 1

      child_buffer = if child.instance_of?(RubyVM::AbstractSyntaxTree::Node)
                       traverse(child)
                     else
                       pretty_element(node: node, index: index)
                     end.lines

      buffer << draw_line(token: child_buffer.shift, last_element: last_element)

      child_buffer.each do |line|
        buffer << draw_space(last_element: last_element) + line
      end
    end

    buffer
  end

  def pretty_element(node:, index:)
    klass = PrettyNode.const_get(node.type)
    klass.new(node).stringify_element(index)
  end

  def stringify_node(node)
    "<%s> [%d:%d-%d:%d]\n" % [node.type.to_s.colorize(:green), node.first_lineno, node.first_column, node.last_lineno, node.last_column]
  end

  def draw_space(last_element:)
    last_element ? ' ' * SPACE_SIZE : I_LINE + ' ' * (SPACE_SIZE - 1)
  end

  def draw_line(token:, last_element:)
    '%s %s' % [last_element ? L_LINE : T_LINE, token]
  end
end
