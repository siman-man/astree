class ASTree::PrettyNode::NEXT < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'value'
    end
  end
end
