class ASTree::PrettyNode::CONST < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'const name'
    end
  end
end
