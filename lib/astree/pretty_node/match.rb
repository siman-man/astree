class ASTree::PrettyNode::MATCH < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(regexp)'
    end
  end
end
