class ASTree::PrettyNode::VCALL < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(method id)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
