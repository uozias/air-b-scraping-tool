class MechanizeBrowser < Browser

  @form = nil
  @error = false # エラーフラグ
  RETRY_MAX = 5 # 最大リトライ回数

  # 初期化
  def initialize
    #@mechanize = Mechanize.new
    @mechanize=  Mechanize.new {|a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE}
    @mechanize.user_agent_alias = 'Windows IE 7'
    @mechanize.read_timeout = 180
    super
  end

  def agent
    @mechanize
  end

  def form
    @form
  end

  def kill_process


  end

  #
  # 特定のURLにアクセス
  #
  def go_to_page(url)
    try_num = 0

    begin
      try_num += 1
      @mechanize.get(url)
      @page = @mechanize.page
    rescue => e
      puts e.message
      if try_num <= RETRY_MAX
        puts 'retry '+try_num.to_s + ' times'
        sleep 3
        retry
      else
        @error = true
        puts e.message
        raise
      end
    ensure
      #puts 'retry終了'
    end
    @page
  end

  #
  # POSTアクセスする
  #
  def post(url, data)
    @mechanize.post(url, data)
    @page = @mechanize.page
  end

  def rails_remote_patch(url, data, header={})

    params = ''
    data.each  do |key, val|
      if params.blank?
        params += '?'
      else
        params += '&'
      end
      params += key + '=' + val
    end
    url += params

    @mechanize.request_with_entity 'patch', url, '', header
    @page = @mechanize.page
  end

  def download(path, target_dir='tmp', file_name=nil)

    split = path.split('/')
    if split.blank?
      return ''
    end

    extension = nil
    if file_name.blank?
      file_name = split[split.count-1]
      extension = ''
      split = file_name.split '.'

      unless split.nil?
        if split.count > 1
          file_name = split[0]
          extension = split[1]
        end
      end
    end

    place = DateTime.now.strftime("%Y%m%d")

    dir =  File.join(Dir.pwd, target_dir+'/'+place)
    unless File.exist? dir
      Dir.mkdir dir
    end

    if extension.present?
      fn2 = file_name+'.'+extension
    else
      fn2 = file_name
    end


    local_path = File.join(dir, fn2)

    @mechanize.download(path, local_path)

    local_path

  end


  #
  # form_nameで示されたフォーム中のnameで示されたinput要素にqueryを入力
  #
  def input(query, name, form_id: nil, form_number: nil)

    unless form_id.nil?
      @form = @page.form_with(id: form_id)
    end

    unless form_number.nil?
      @form = @page.forms[form_number]
    end

    if @form.nil?
      return nil
    end

    #
    # フールド取得
    #
    field = @form.fields_with(name: name).first

    if field.nil?
      field = @form.checkboxes_with(value: query).first
    end


    #
    # 選択
    #
    if field.present?
      if field.is_a? Mechanize::Form::SelectList
        field.option_with(:value => query).select
        return
      end

      if field.is_a? Mechanize::Form::CheckBox
        field.check
      else
        field.value = query
      end
    else
      LogHelper.info('field is not found: ' + name)
    end

  end

  #
  # xpathで示されたフォームをサブミット
  #
  def submit
    if @form.nil?
      @form = @page.forms[0]
    end
    if @form.nil?
      return false
    end
    @page = @form.submit
  end

  #
  # xpathで示された要素のリストを返す
  #
  def find(xpath)
    @page.search(xpath)
  end

  def page
    @page
  end

  #
  # 今いるページのhtmlを取得
  #
  def get_html
    target = ''
    unless @error
      target = @page.body
    end

    @nokogiri = Nokogiri::HTML(target)
    @nokogiri
  end

  #
  # クリックする
  #
  def click_form_button(name)
    if @form.nil?
      return false
    end
    @form.click_button(@form.button_with(name: name))
  end


  def get_content(node, target: :text)
    self.class.get_content(node, target: target)
  end

  #
  # 当該要素の内容テキストを返す
  # node: nokogirオブジェクト
  #
  def self.get_content(node, target: :text)
    if node.blank?
      return nil
    end
    if node.is_a? Nokogiri::XML::NodeSet
     node = node[0]
    end
    case target
      when :href
        node['href']
      when :text
        node.text
      else
        node[target]
    end
  end

  def to_utf8
    if @page.present?
      @page.encoding = "utf-8"
    end
  end
end
