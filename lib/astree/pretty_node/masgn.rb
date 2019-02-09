class ASTree::PrettyNode::MASGN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(left hand side)'
    when 2
      '(rest variable)'
    end
  end
end
