class ASTree::PrettyNode::SCOPE < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'local table'
    when 1
      'arguments'
    when 2
      'body'
    end
  end
end
