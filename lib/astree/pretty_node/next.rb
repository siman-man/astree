class ASTree::PrettyNode::NEXT < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(value)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
