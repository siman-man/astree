class ASTree::PrettyNode::CASE2 < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(condition)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
