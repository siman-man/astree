class ASTree::PrettyNode::BEGIN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(body)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
