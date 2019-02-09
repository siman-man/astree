class ASTree::PrettyNode::OP_ASGN2 < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      'unknown'
    when 2
      'field name'
    end
  end
end
