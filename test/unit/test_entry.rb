require 'helper'

class TestEntry < Test::Unit::TestCase
  def setup
    @entry = Pwl::Entry.new
  end

  def test_construction_state
    assert(!@entry.valid?)
    assert_not_nil(@entry.uuid)
  end

  def test_uuid_assign_nil
    @entry.name = 'test_uuid_assign_nil'
    @entry.uuid = nil
    assert(!@entry.valid?)
  end

  def test_uuid_assign_empty
    @entry.name = 'test_uuid_assign_empty'
    @entry.uuid = ''
    assert(!@entry.valid?)
  end

  def test_uuid_assign_invalid
    @entry.name = 'test_uuid_assign_invalid'
    @entry.uuid = 'invalid'
    assert(!@entry.valid?)
  end

  def test_uuid_assign_valid
    @entry.name = 'test_uuid_assign_valid'
    @entry.password = 'password is require to be valid'
    @entry.uuid = 'b1f75370-979c-012f-eed1-70def14c3504'
    assert(@entry.valid?)
  end

  def test_name_assign
    name = 'foobar'
    @entry.name = name
    assert_equal(name, @entry.name)

    @entry.password = 'password is require to be valid'
    assert(@entry.valid?)
  end

  def test_name_construction
    name = 'foobar'
    @entry = Pwl::Entry.new(name)
    assert_equal(name, @entry.name)

    @entry.password = 'password is require to be valid'
    assert(@entry.valid?)
  end

  def test_name_assign_nil
    assert_nil(@entry.name)
    assert(!@entry.valid?)
  end

  def test_name_assign_empty
    name = ''
    @entry.name = name
    assert_equal(name, @entry.name)
    assert(!@entry.valid?)
  end
end
