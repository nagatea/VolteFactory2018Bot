require 'minitest/autorun'
require "../volte_factory.rb"

class TestSample < Minitest::Test
  def setup
    @vol = VolteFactory.new
  end

  def test_get_shop_url
    list = ["高津", "渋谷"]
    list.each do |word|
      res = @vol.get_shop_url(word)
      puts res
      assert_match /shop/, res
      assert_match /voltefactory/, res 
    end
  end

  def test_get_zaiko
    list = ["高津", "渋谷"]
    list.each do |word|
      res = @vol.get_zaiko(word)
      assert res.length > 0 
      assert_match /#{word}/, res
      assert_match /残り/, res
      assert_match /抽選/, res
    end
  end
end