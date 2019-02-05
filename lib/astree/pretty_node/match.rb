class ASTree::PrettyNode::MATCH < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(regexp)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
