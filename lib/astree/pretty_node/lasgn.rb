class ASTree::PrettyNode::LASGN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(variable name)'
    when 1
      ''
    end
  end
end
