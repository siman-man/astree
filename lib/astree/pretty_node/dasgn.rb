class ASTree::PrettyNode::DASGN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(variable name)'
    when 1
      '(unknown)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
