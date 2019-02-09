class ASTree::PrettyNode::DREGX < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(preceding string)'
    when 2
      '(tailing string)'
    end
  end
end
