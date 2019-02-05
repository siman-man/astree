class ASTree::PrettyNode::KW_ARG < ASTree::PrettyNode
  def label_name(index)
    case index
    when 1
      '(next kw_arg)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
