class Node

  attr_reader :children

  def initialize()
    @children = {}
    @children[:end] = false
  end

  def has_child?(letter)
    if letter.class != String
      return false
    end

    return @children.keys.include?(letter[0].downcase.to_sym)
  end

  def add_child(letter)
    return nil if letter.class != String
    if !has_child?(letter)
      @children[letter[0].to_sym] = Node.new
    end
    return @children[letter[0].to_sym]
  end

  def get_child(letter)
    return nil if letter.class != String
    return @children[letter[0].to_sym]
  end

  # def end_of_word?
  #   @children[:end]
  # end

end
