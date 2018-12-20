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
    tmp = page.search(xpath).to_s.split("</div>")
    tmp.each do |po|
      po.gsub!(/<div.+l">/,"")
      po.encode!("UTF-8", "Shift_JIS")
    end

    tmp[0] = "サントラ"

    for i in 0..6 do
      tmp[i*3].gsub!("オリジナル\se-amusement\spass\s","・")
      tmp[i*3].gsub!("クリアポスター\s-MEMORIAL\sMODEL-\s","・")
    end

    for i in 0..6 do
      tmp[i*3+1].gsub!(" ", "")
      tmp[i*3+1] = "(#{tmp[i*3+1]})"
    end

    for i in 0..6 do
      tmp[i*3+2].gsub!(/<.+\//,"")
      tmp[i*3+2].gsub!(/\..+>/,"")
      tmp[i*3+2].gsub!("zaiko_nijumaru","(◎)")
      tmp[i*3+2].gsub!("zaiko_maru","(○)")
      tmp[i*3+2].gsub!("zaiko_sankaku1","(△)")
      tmp[i*3+2].gsub!("zaiko_sankaku2","(△残りわずか！)")
      tmp[i*3+2].gsub!("zaiko_batsu","(×)")
    end

    res = Array.new(7, "")

    for i in 0..6 do
      res[i] = tmp[i*3] + tmp[i*3+1] + tmp[i*3+2]
    end

    res.insert(1, "オリジナルe-pass")
    res.insert(4, "クリアポスター")

    res.join("\n")
  end
end

