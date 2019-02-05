class ASTree::PrettyNode::DSYM < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      '(preceding string)'
    when 2
      '(tailing string)'
    else
      raise "Unexpected index [#{index}]."
    end
  end
end
