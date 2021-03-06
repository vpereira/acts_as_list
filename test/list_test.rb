require File.expand_path(File.join(File.dirname(__FILE__),'..','init'))
require 'test/unit'

class Array
  def move(from, to)
    insert(to, delete_at(from))
  end
end

#TODO the other tests should be refactored as ArrayScopeListTest

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :articles do |t|
      t.column :position, :integer
      t.column :parent_id, :integer
      t.column :parent_type, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Article < ActiveRecord::Base
  acts_as_list :scope => :parent
end

class ListTest < Test::Unit::TestCase
  def setup
    @myItems = []
    setup_db
    (1..4).each do |counter| 
      Article.create! :position => counter, :parent_id => 5 
      @myItems.push Article.where(:parent_id=> 5).last.id
    end
    @articles = Article.where(:parent_id=> 5).order(:position)
  end

  def teardown
    teardown_db
  end

  def test_methods_available_for_array
      myArray = []
      assert myArray.respond_to?(:move)
  end

  def test_methods_available_for_list
    @article = Article.first
    assert @article.respond_to?(:move_to_bottom)
    assert @article.respond_to?(:move_higher)
  end

  def test_injection
    item = Article.new(:parent_id => 1)
    assert_equal '"articles"."parent_id" = 1', item.scope_condition
    assert_equal "position", item.position_column
  end

  def test_insert
    new = Article.create(:parent_id => 20)
    assert_equal 1, new.position
    assert new.first?
    assert new.last?
  end

  def test_items_are_ordered
    assert_equal @myItems, @articles.all.map(&:id)
  end

  def test_move_lower
    Article.find(2).move_lower
    assert_equal @myItems.move(1,2), @articles.all.map(&:id)
  end

  def test_move_higher
    Article.find(2).move_higher
    assert_equal @myItems.move(0,1), @articles.all.map(&:id)
  end

  def test_move_to_bottom
    Article.first.move_to_bottom
    assert_equal @myItems.move(0,-1), @articles.all.map(&:id)
  end

  def test_move_to_top
    Article.last.move_to_top
    assert_equal @myItems.move(-1,0), @articles.all.map(&:id)
  end

  def test_nil_return
    assert_equal Article.find(2), Article.find(1).lower_item
    assert_nil Article.first.higher_item
    assert_equal Article.find(3), Article.find(4).higher_item
    assert_nil Article.last.lower_item
  end

  def test_delete_middle
    Article.find(3).destroy
    @myItems.delete_at(2)
    assert_equal @myItems, Article.where(:parent_id=>5).all.map(&:id)
  end
end

#class ArrayScopeListTest < Test::Unit::TestCase
#
#  def setup
#    @myItems = []
#    Article.send :acts_as_list, :column => "position", :scope => [:parent_id, :parent_type]
#
#    setup_db
#    (1..4).each do |counter| 
#      Article.create! :position => counter, :parent_id => 5, :parent_type => 'ParentClass'
#      @myItems.push Article.last.id
#    end
#    @articles = Article.where(:parent_id=> 5,:parent_type=>'ParentClass').order(:position)
#  end
#
#  def teardown
#    teardown_db
#  end
#
#  def test_injection
#    item = Article.new(:parent_id => 1)
#    assert_equal '"articles"."parent_id" = 1 AND "articles"."parent_type" IS NULL', item.scope_condition
#    assert_equal "position", item.position_column
#  end
#
#  def test_insert
#    new = Article.create :parent_id => 20, :parent_type => 'ParentClass'
#    assert_equal 1, new.position
#    assert new.first?
#    assert new.last?
#  end
#
#  def test_items_are_ordered
#    assert_equal @myItems, @articles.all.map(&:id)
#  end
#
#  def test_move_lower
#    Article.find(2).move_lower
#    assert_equal @myItems.move(1,2), @articles.all.map(&:id)
#  end
#
#  def test_move_higher
#    Article.find(2).move_higher
#    assert_equal @myItems.move(0,1), @articles.all.map(&:id)
#  end
#
#  def test_move_to_bottom
#    Article.first.move_to_bottom
#    assert_equal @myItems.move(0,-1), @articles.all.map(&:id)
#  end
#
#  def test_move_to_top
#    Article.last.move_to_top
#    assert_equal @myItems.move(-1,0), @articles.all.map(&:id)
#  end
#
#  def test_nil_return
#    assert_equal Article.find(2), Article.find(1).lower_item
#    assert_nil Article.first.higher_item
#    assert_equal Article.find(3), Article.find(4).higher_item
#    assert_nil Article.last.lower_item
#  end
#end

#class ScopeAsStringTest < Test::Unit::TestCase
#  def setup
#    setup_db
#    Article.send :acts_as_list, :column => "position", :scope => 'parent_id = #{parent_id}'
#  end
#
#  def teardown
#    teardown_db
#  end
#
#  def test_with_string_based_scope
#    new = Article.create(:parent_id => 500)
#    assert_equal 1, new.position
#    assert new.first?
#    assert new.last?
#  end
#
#end
#
#
#
