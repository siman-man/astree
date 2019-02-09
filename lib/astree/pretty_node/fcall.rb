class ASTree::PrettyNode::FCALL < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(method id)'
    when 1
      '(arguments)'
    end
  end
end
