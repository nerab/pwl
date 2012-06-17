require 'helper'

class TestEntryMapper < Test::Unit::TestCase
  def setup
    @entry = Pwl::Entry.new
    @entry.name = 'foobar'
    @entry.password = 'barfoot'
  end

  def test_from_json
    entry = Pwl::EntryMapper.from_json(%q|{"uuid" : "7a1fd920-97bb-012f-eee8-70def14c3504", "name" : "something"}|)
    assert_not_nil(entry)
    assert_not_nil(entry.uuid)
    assert_equal('7a1fd920-97bb-012f-eee8-70def14c3504', entry.uuid)
    assert_equal('something', entry.name)
  end

  def test_to_json
    json = Pwl::EntryMapper.to_json(@entry)
    assert_not_nil(json)
    entry = JSON(json)
    assert_present(entry['uuid'])
    assert_equal('foobar', entry['name'])
  end

  def test_happy_path
    entry = Pwl::EntryMapper.from_json(Pwl::EntryMapper.to_json(@entry))
    assert_not_nil(entry)
    assert_not_nil(entry.uuid)
    assert_equal(@entry.uuid, entry.uuid)
    assert_equal('foobar', entry.name)
  end
end
