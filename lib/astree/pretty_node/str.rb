class ASTree::PrettyNode::STR < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(value)'
    end
  end
end
