class ASTree::PrettyNode::RESCUE < ASTree::PrettyNode
  def label_name(index)
    case index
    when 2
      'next clause'
    end
  end
end
