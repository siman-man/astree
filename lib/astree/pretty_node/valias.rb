class ASTree::PrettyNode::VALIAS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'new name'
    when 1
      'old name'
    end
  end
end
