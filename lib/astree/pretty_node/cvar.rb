class ASTree::PrettyNode::CVAR < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'variable name'
    end
  end
end
