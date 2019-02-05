class ASTree::PrettyNode::WHEN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 2
      '(next clause)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
