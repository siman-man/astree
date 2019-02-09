class ASTree::PrettyNode::VCALL < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(method id)'
    end
  end
end
