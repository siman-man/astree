class ASTree::PrettyNode::WHEN < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(body)'
    when 2
      '(next clause)'
    end
  end
end
