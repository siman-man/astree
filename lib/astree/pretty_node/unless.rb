class ASTree::PrettyNode::UNLESS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 2
      '(else clause)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
