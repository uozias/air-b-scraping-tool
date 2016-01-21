require 'capybara'
require 'capybara/poltergeist'

class PoltergeistBrowser < Browser

  # 初期化
  def initialize

    @poltergeist = nil

    Capybara.run_server = false

    options = {
      :js_errors => false, :timeout => 500, inspector: false, debug:false,
      :phantomjs_options => ['--ssl-protocol=tlsv1']
    }
    #options[:logger]=File.open("#{Rails.root}/log/debug_phantomjs.log", "a")
    #options[:phantomjs_logger]=File.open("#{Rails.root}/log/phantomjs.log", "a")

    # if Rails.env.production?
    #   options[:phantomjs] = '/home/rails/phantomjs/bin/phantomjs'
    # end

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app,
                                        options
      )
    end
    Capybara.default_selector = :xpath
    Capybara.ignore_hidden_elements = true
    Capybara.javascript_driver = :poltergeist
    @poltergeist = Capybara::Session.new(:poltergeist)

    @poltergeist.driver.headers = {
        Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Language'=> 'ja,en-US;q=0.8,en;q=0.6',
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.94 Safari/537.36" ,
        Connection: 'keep-alive'
    }

  end

  def agent
    @poltergeist
  end

  def kill_process
    if @poltergeist.present?
      @poltergeist.driver.quit
    end
  end

  #
  # 特定のURLにアクセス
  #
  def go_to_page(url)
    @poltergeist.visit(url)
  end

  def get_native
    @poltergeist
  end


  #
  # ログイン
  #
  def login(form_id, name_value_pairs, login_button_id)
    @poltergeist.within("//form[@id='#{form_id}']") do
      name_value_pairs.each do |name_value_pair|
        @poltergeist.fill_in name_value_pair[:name], :with => name_value_pair[:value]
      end
    end
    self.click("//*[@id='#{login_button_id}']")
  end

  #
  # xpathで示されたinput要素にqueryを入力
  #
  def input(query, xpath)
    if xpath.is_a? String
      #@poltergeist.fill_in xpath, with: query
      element = @poltergeist.find(:xpath, xpath)
      element.set(query)
    end

    if xpath.is_a? Capybara::Node::Element
      xpath.set query
    end
  end


  #
  # xpathで示された選択肢を選ぶ
  #
  def select(option_xpath)
    if option_xpath.is_a? String
      @poltergeist.find(:xpath, option_xpath).select_option
    end
    if option_xpath.is_a? Capybara::Node::Element
      option_xpath.select_option
    end

  end


  #
  # xpathで示された要素のリストを返す
  #
  def find(xpath)
    @poltergeist.find(:xpath, xpath)
  end

  def all(xpath)
    @poltergeist.all(:xpath, xpath)
  end

  #
  # 当該要素をクリック
  #
  def click(xpath)
    if xpath.is_a? String
      @poltergeist.find(:xpath, xpath).click
    end
    if xpath.is_a? Capybara::Result
      xpath[0].click
    end
    if xpath.is_a? Capybara::Node::Element
      xpath.click
    end

  end

  #
  # dialog確定
  #
  def confirm_dialog_before
    @poltergeist.execute_script('window.confirm = function() { return true; }')
    #@poltergeist.driver.browser.switch_to.alert.accept
  end

  #
  # js実行
  #
  def script(script_string)
    @poltergeist.execute_script(script_string)
  end

  def evaluate_script(script_string)
    @poltergeist.evaluate_script(script_string)
  end

  #
  # ファイルアップロード
  #
  def upload(file_input_xpath, file_path)
    #absolute_path = "#{Rails.root}/images/#{file_name}"
    @poltergeist.attach_file file_input_xpath, file_path

  end

  #
  # ファイル添付
  #
  def attach_file(file_input_xpath, file_path)
    begin
      upload(file_input_xpath, file_path)
    rescue => e
      puts e.message
    end

  end

  # def absolute_path(file_name)
  #   "#{Rails.root}/images/#{file_name}"
  # end

  #
  # ダウンロード
  #
  # 返り値 ダウンロードされたファイルのローカルパス
  def download(path, target_dir='tmp')
    if path.nil?
      return ''
    end

    @poltergeist.execute_script("window.getFile = function(url) { var xhr = new XMLHttpRequest();  xhr.open('GET', url, false);  xhr.send(null); return xhr.responseText; }")


    split = path.split('/')
    if split.blank?
      return ''
    end

    file_name = split[split.count-1]
    split = file_name.split '.'

    unless split.nil?
      if split.count > 1
        file_name = split[0]
        extension = split[1]
      end
    end

    place = DateTime.now.strftime("%Y%m%d")

    data = @poltergeist.evaluate_script("getFile('"+path+"')")
    local_path = File.join(Rails.root, target_dir+"/"+place, file_name+'.'+extension)
    File.write(local_path, data)

    local_path
  end


  #
  # スクショ取る
  #
  def screenshot(name=nil)


    #return if Rails.env.production?

    if name.blank?
      name = 'screenshot'
    end
    @poltergeist.save_screenshot("capture/#{name}.png", :full => true)

  end

  #特定の要素の存在を待つヘルパー
  def wait_for(xpath_string, interval = 4, repeat = 3)
    elements = nil
    cnt_retry = 0

    #pp "repeat: " + repeat.to_s
    #pp "interval: " + interval.to_s
    begin
      cnt_retry += 1
      if cnt_retry > repeat
        break
      end
      #@page.save_screenshot('capture/' + cnt_retry.to_s + '.png', :full => true)
      elements = @poltergeist.all(:xpath, xpath_string)
      unless elements.blank?
        #pp "key element found."
        break
      end
      sleep interval.seconds
    rescue =>e
      pp e.message

      sleep interval.seconds
      retry
    end while true

    elements

  end

  #
  # phantomjsのkill
  #
  def self.kill_all_browser
    begin
      res = `pgrep -f phantomjs`
      arr = [];res.each_line("\n"){|l|arr.append l.chomp}
      arr.each do |pid|
        `kill -9 #{pid}`
      end
    rescue => e
      puts e.message
    end

  end



end