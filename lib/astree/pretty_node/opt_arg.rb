class ASTree::PrettyNode::OPT_ARG < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      'next opt_arg'
    end
  end
end
