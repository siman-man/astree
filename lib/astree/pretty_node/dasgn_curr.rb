class ASTree::PrettyNode::DASGN_CURR < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(variable name)'
    when 1
      '(unknown)'
    end
  end
end
