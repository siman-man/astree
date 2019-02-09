class ASTree::PrettyNode::UNLESS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 2
      '(else clause)'
    end
  end
end
