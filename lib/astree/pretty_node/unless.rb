class ASTree::PrettyNode::UNLESS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(then clause)'
    when 2
      '(else clause)'
    end
  end
end
