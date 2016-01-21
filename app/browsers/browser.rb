class Browser

  #
  # 特定のURLにアクセス
  #
  def go_to_page(url)

  end

  #
  # POSTアクセスする
  #
  def post(url, data)

  end

  #
  # 今いるページのhtmlを取得
  #
  def get_html

  end

  #
  # xpathで示されたinput要素にqueryを入力
  #
  def input(query, xpath)

  end

  #
  # xpathで示されたボタンを押す
  #
  def push_button(xpath)

  end

  #
  # xpathで示されたフォームをサブミット
  #
  def submit(xpath)

  end


  #
  # xpathで示された要素のリストを返す
  #
  def find(xpath)

  end

  #
  # 当該要素の内容テキストを返す
  #
  #
  def self.get_content(node, target: :text)

  end
end