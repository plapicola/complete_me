require_relative 'test_helper'
$test
class CompleteMeTest < Minitest::Test

  def test_it_exists
    # skip
    complete = CompleteMe.new
    assert_instance_of CompleteMe, complete
  end

  def test_it_counts_words_inserted
    # skip
    complete = CompleteMe.new
    assert_equal 0, complete.count
  end

  def test_it_can_insert_words
    # skip
    complete = CompleteMe.new
    complete.insert("pizza")
    assert_equal 1, complete.count
  end

  def test_it_can_make_suggestions
    # skip
    complete = CompleteMe.new
    complete.insert("pizza")
    assert_equal ["pizza"], complete.suggest("piz")
  end

  def test_it_can_load_a_dictionary
    # skip
    dictionary = File.readlines("/usr/share/dict/words")
    complete = CompleteMe.new
    complete.populate(dictionary)
    assert_equal dictionary.length, complete.count
    suggestions = complete.suggest("piz")
    expected = dictionary.find_all{|word| word[0..2] == "piz"}
    expected = expected.map {|word| word = word.chomp}

    assert_equal expected, suggestions
  end

  def test_it_can_adjust_suggestions_based_on_selections
    # skip
    dictionary = File.readlines("/usr/share/dict/words")
    complete = CompleteMe.new
    complete.populate(dictionary)

    complete.select("piz", "pizza")
    complete.select("piz", "pizza")
    complete.select("piz", "pizza")
    complete.select("pizz", "pizzeria")
    complete.select("pizz", "pizzeria")
    complete.select("pizz", "pizzeria")

    assert_equal "pizza", complete.suggest("piz").first
    assert_equal "pizzeria", complete.suggest("pizz").first
  end

  def test_words_can_be_deleted
    # skip
    dictionary = IO.readlines("/usr/share/dict/words")
    complete = CompleteMe.new
    complete.populate(dictionary)

    expected = complete.suggest("piz")
    expected.delete("pizza")
    complete.delete("pizza")

    assert_equal expected, complete.suggest("piz")
  end

  def test_deleted_words_dont_delete_children
    # skip
    dictionary = IO.readlines("/usr/share/dict/words")
    complete = CompleteMe.new
    complete.populate(dictionary)

    expected = complete.suggest("rabb")
    expected.delete("rabbi")
    complete.delete("rabbi")

    assert_equal expected, complete.suggest("rabb")
  end

  def test_deleting_words_not_in_trie_doesnt_affect_trie
    dictionary = IO.readlines("/usr/share/dict/words")
    complete = CompleteMe.new
    complete.populate(dictionary)

    expected = complete.suggest("piz")
    complete.delete("pizt")

    assert_equal expected, complete.suggest("piz")
  end

end
