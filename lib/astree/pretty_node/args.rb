class ASTree::PrettyNode::ARGS < ASTree::PrettyNode
  def label_name(index)
    case index
    when 0
      'pre_num'
    when 1
      'pre_init'
    when 2
      'opt'
    when 3
      'first_post'
    when 4
      'post_num'
    when 5
      'post_init'
    when 6
      'rest'
    when 7
      'kw'
    when 8
      'kwrest'
    when 9
      'block'
    end
  end
end
