require_relative 'node'
require 'io/console'

class CompleteMe

  attr_reader :count

  def initialize
    @root = Node.new
    @count = 0
    @selections = Hash.new(Hash.new(0))
  end

  def insert(word)
    first = generate_next(@root, word)
    @count += 1
    insert_word(first, word[1..-1])
  end

  def realtime
    chars = []
    length = 4
    suggestion = []
    loop do
      char = STDIN.getch
      if char == "\t"
        select(array_as_string(chars), suggestion.first)
        binding.pry
        break
      elsif ["\n", "\r\n", "\r"].include?(char)
        insert(array_as_string(chars))
        break
      end
      chars << char
      # binding.pry
      if chars.length > 3
        suggestion = suggest(array_as_string(chars))
        print "#{"\b" * length}"
        print "#{" " * length}"
        # binding.pry
        print "#{"\b" * length}"
        print suggestion.first
        length = suggestion.first.length unless suggestion == []
        # binding.pry
      else
        print char
      end
    end
  end

  def array_as_string(array)
    array.inject("") do |substring, letter|
      substring + letter
    end
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
    suggestions =  navigate_to_substring(first, partial_string, 1)
    sort_suggestions(suggestions, partial_string)
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

  def select(substring, selection)
    if @selections.include?(substring)
      if @selections[substring].include?(selection)
        @selections[substring][selection] += 1
      else
        @selections[substring][selection] = 1
      end
    else
      @selections[substring] = {selection => 1}
      @selections[substring].default=(0)
    end
  end

  def sort_suggestions(suggestions, partial_string)
    current = 0
    largest = 0
    while current < suggestions.length
      array_traveler = current
      largest = current
      while array_traveler < suggestions.length
        # binding.pry
        if (@selections[partial_string][suggestions[array_traveler]] >
           @selections[partial_string][suggestions[current]])
           largest = array_traveler
        end
        array_traveler += 1
      end
      swap(current, largest, suggestions)
      current += 1
    end
    return suggestions
  end

  def swap(first, second, suggestions)
    temp = suggestions[first]
    suggestions[first] = suggestions[second]
    suggestions[second] = temp
  end

  def delete(word)
    delete_word(@root, word, 0)
  end

  def delete_word(current, word, index)
    if index == word.length
      current.children[:end] = false
      return current.children.count > 1
    end

    if current.children[word[index].to_sym] == nil
      return true
    end

    if delete_word(current.children[word[index].to_sym], word, index + 1)
      return true
    else
      current.children.delete(word[index].to_sym)
      return current.children.count > 1
    end
  end

  # Navigate to node, change end flag, return boolean if has children
  # if recieve true, return true, else, delete node and return if children remain

end
