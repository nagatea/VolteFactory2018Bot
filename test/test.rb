require 'minitest/autorun'
require "../volte_factory.rb"

class TestSample < Minitest::Test
  def setup
    @vol = VolteFactory.new
  end

  def test_get_shop_url
    assert_match /shop/, @vol.get_shop_url 
  end

  def test_get_zaiko
    res = @vol.get_zaiko
    assert res.length > 0 
    assert_match /VP/, res
    assert_match /サントラ/, res
    assert_match /レイシス/, res
    assert_match /ニアノア/, res
    assert_match /BOOTH/, res
    assert_match /INFINITE/, res
    assert_match /GRAVITY/, res
    assert_match /HEAVENLY/, res
  end
end