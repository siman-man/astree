class ASTree::PrettyNode::RESBODY < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(rescue clause list)'
    when 2
      '(next clause)'
    end
  end
end
