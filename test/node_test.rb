require_relative 'test_helper'

class NodeTest < Minitest::Test

  def test_it_exists
    node = Node.new
    assert_instance_of Node, node
  end

  def test_node_contains_a_hash_of_symbols
    node = Node.new
    assert_instance_of Hash, node.children
    assert_instance_of Symbol, node.children.keys.first
  end

  # def test_node_hash_values_are_nodes
  #   node_1 = Node.new
  #
  #   node_2 = node_1.add_child("h")
  #   node_3 = node_1.add_child("i", true)
  #   assert_equal node_2, node_1.get_child("h")
  #   assert_equal node_3, node_1.get_child("i")
  # end
  #
  # def test_node_knows_if_end_of_string
  #   node_1 = Node.new
  #   node_2 = node_1.add_child("n")
  #   node_3 = node_2.add_child("o", true)
  #
  #   assert node_3.end_of_word?
  #   refute node_2.end_of_word?
  # end
end
