class ASTree::PrettyNode::OP_ASGN_OR < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(operator)'
    end
  end
end
