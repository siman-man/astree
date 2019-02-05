class ASTree::PrettyNode::ATTRASGN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(method id)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
