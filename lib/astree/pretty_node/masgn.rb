class ASTree::PrettyNode::MASGN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(right hand side)'
    when 1
      '(left hand side)'
    when 2
      '(rest variable)'
    end
  end
end
