class ASTree::PrettyNode::CDECL < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(const name)'
    when 1
      '(const name)'
    end
  end
end
