class ASTree::PrettyNode::BLOCK_PASS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'other arguments'
    end
  end
end
