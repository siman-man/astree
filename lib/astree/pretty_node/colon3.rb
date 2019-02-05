class ASTree::PrettyNode::COLON3 < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(const name)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
