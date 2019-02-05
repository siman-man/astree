class ASTree::PrettyNode::OP_ASGN1 < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(operator)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
