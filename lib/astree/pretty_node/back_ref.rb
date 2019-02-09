class ASTree::PrettyNode::BACK_REF < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'variable name'
    end
  end
end
