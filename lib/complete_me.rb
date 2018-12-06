require_relative 'node'

class CompleteMe

  attr_reader :count

  def initialize
    @root = Node.new
    @count = 0
  end

  def insert(word)
    first = get_required_child(@root, word)
    @count += 1
    insert_word(first, word[1..-1])
  end

  def get_required_child(current, letter)
    if current.has_child?(letter[0])
      next_node = current.get_child(letter[0])
    else
      next_node = current.add_child(letter[0])
    end
  end

  def insert_word(current, word)
    if word.length == 0
      current.children[:end] = true
      return
    end
    next_node = get_required_child(current, word)
    insert_word(next_node, word[1..-1])
  end

end
