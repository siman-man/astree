class ASTree::PrettyNode::CLASS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(super class)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
