class ASTree::PrettyNode::QCALL < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      'method id'
    when 2
      'arguments'
    end
  end
end
