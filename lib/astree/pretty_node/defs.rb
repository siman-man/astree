class ASTree::PrettyNode::DEFS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      'method id'
    end
  end
end
