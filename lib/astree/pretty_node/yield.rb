class ASTree::PrettyNode::YIELD < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'arguments'
    end
  end
end
