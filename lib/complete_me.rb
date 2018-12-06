require_relative 'node'

class CompleteMe

  attr_reader :count

  def initialize
    @root = Node.new
    @count = 0
  end

  def insert(word)
    first = generate_next(@root, word)
    @count += 1
    insert_word(first, word[1..-1])
  end

  def generate_next(current, letter)
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
    next_node = generate_next(current, word)
    insert_word(next_node, word[1..-1])
  end

  def suggest(partial_string)
    first = find_next(@root, partial_string[0])
    return navigate_to_substring(first, partial_string, 1)
  end

  def navigate_to_substring(current, partial_string, index)
    if partial_string.length == index
      completed_strings = []
      return gather_all_completions(current, completed_strings, partial_string)
    end
    next_node = find_next(current, partial_string[index])
    if next_node == []
      return next_node
    end
    return navigate_to_substring(next_node, partial_string, index + 1)
  end

  def find_next(current, letter)
    if current.has_child?(letter)
      next_node = current.get_child(letter.to_s)
    else
      return []
    end
  end

  def gather_all_completions(current, found_strings, word)
    if current.children[:end]
      found_strings << word
    end

    current.children.each do |key, node|
      if key != :end
        gather_all_completions(node, found_strings, (word + key.to_s))
      end
    end
    return found_strings
  end

  def populate (file)
    file.each do |word|
      insert(word.chomp)
    end
  end

end

# Suggestion Method:
# Navigate to node for substring
#     -  Return empty array for substring not in trie
# Once node found, generate empty array
# Recursively call each child of that array, adding called letter to calling
# string, when a :end is hit, add string to array
