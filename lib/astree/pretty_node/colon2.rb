class ASTree::PrettyNode::COLON2 < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'const path'
    when 1
      'const name'
    end
  end
end
