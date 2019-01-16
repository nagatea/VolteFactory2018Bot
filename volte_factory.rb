require 'open-uri'
require 'mechanize'

class VolteFactory
  def initialize
    @agent = Mechanize.new
    @agent.max_history = 1
    @agent.open_timeout = 30
    @agent.read_timeout = 60
  end

  def get_shop_url #何故か日によって店舗idが違うので検索からurlをとってくる
    url = "https://p.eagate.573.jp/game/sdvx/iv/p/search/list.html?pref=14&search_word=%8D%82%92%C3&pcb_cnt=0"
    page = @agent.get(url)
    page.encoding = 'Shift_JIS'
    xpath = '//*[@id="waku_center"]/div[5]/table/tr/td[3]/a'
    shop_url = page.search(xpath).attribute('href').value
    "https://p.eagate.573.jp" + shop_url
  end

  def get_zaiko
    url = self.get_shop_url
    page = @agent.get(url)
    page.encoding = 'Shift_JIS'
    xpath = "//*[@id='vp_goods_info_val']"
    search = page.search(xpath).to_s.split("</div>")
    search.each do |tmp|
      tmp.gsub!(/<div.+l">/,"")
      tmp.encode!("UTF-8", "Shift_JIS")
      tmp.gsub!(/<.+\//,"")
      tmp.gsub!(/\..+>/,"")
      tmp.gsub!("zaiko_nijumaru","(◎)\s")
      tmp.gsub!("zaiko_maru","(○)\s")
      tmp.gsub!("zaiko_sankaku1","(△)\s")
      tmp.gsub!("zaiko_sankaku2","(△残りわずか！)\s")
      tmp.gsub!("zaiko_batsu","(×)\s")
      tmp.gsub!(/オリジナル\se-amusement\spass\s.+-\s/,"")
      tmp.gsub!("クリアポスター\s-MEMORIAL\sMODEL-\s","")
      tmp.gsub!(/(\d\d\d)\sVP/){"(#{$1}VP)"}
    end

    search[0] = "サントラ"
    res = Array.new(7, "")

    for i in 0..6 do
      res[i] = search[i*3+2] + search[i*3] + search[i*3+1]
    end

    res.insert(1, "\nオリジナルe-pass")
    res.insert(4, "\nクリアポスター")

    res.join("\n")
  end
end

