require_relative 'test_helper'

class CompleteMeTest < Minitest::Test

  def test_it_exists
    complete = CompleteMe.new
    assert_instance_of CompleteMe, complete
  end

  def test_it_counts_words_inserted
    complete = CompleteMe.new
    assert_equal 0, complete.count
  end

  def test_it_can_insert_words
    complete = CompleteMe.new
    complete.insert("pizza")
    assert_equal 1, complete.count
  end

  def test_it_can_make_suggestions
    complete = CompleteMe.new
    complete.insert("pizza")
    assert_equal ["pizza"], complete.suggest("piz")
  end

  def test_it_can_load_a_dictionary
    dictionary = File.readlines("/usr/share/dict/words")
    complete = CompleteMe.new
    complete.populate(dictionary)
    assert_equal dictionary.length, complete.count
    suggestions = complete.suggest("piz")
    expected = dictionary.find_all{|word| word[0..2] == "piz"}
    expected = expected.map {|word| word = word.chomp}

    assert_equal expected, suggestions
  end

end
