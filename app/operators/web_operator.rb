class WebOperator

  include AsConstants

  TERM = 2.days


  attr_accessor :user, :password

  def initialize
    @browser = PoltergeistBrowser.new
  end


  def login
    result = false

    @browser.go_to_page(LOGIN::URL)

    @browser.click(LOGIN::XPATH::SHOW)

    @browser.input(user, LOGIN::XPATH::EMAIL)
    @browser.input(password, LOGIN::XPATH::PASSWORD)

    @browser.click(LOGIN::XPATH::SUBMIT)

    check_nodes = @browser.all(LOGIN::XPATH::SUCCESS)
    if check_nodes.present?
      result = true
    end

    result
  end


  def rooms(area)


    result = MethodResult.new

    area_name = area.name

    max_page_num_node = @browser.find(ROOMS::XPATH::PAGE_MAX)
    if max_page_num_node.blank?

      # first page only

      result.content= result.content.concat crawl_terms(area)

    else

      # multiple pages

      max_page_num = max_page_num_node.text.to_i
      (1..max_page_num.to_i).each do |number|

        result.content= result.content.concat crawl_terms(area, number)

      end

    end


    result.result = true
    result

  end

  # 指定期間文
  def crawl_terms(area, number=1)

    area_name = area.name

    results = []

    # 今日 から 1ヶ月後まで
    today = Time.zone.now.to_date
    a_month_later = (today + TERM).to_date

    (today..a_month_later).each do |day|
      checkin = day.strftime('%Y-%m-%d')
      checkout = (day + 1.day).strftime('%Y-%m-%d')


      url = SEARCH::HELPER.area_url(area_name, number, checkin, checkout)
      @browser.go_to_page url

      # パース
      results.concat parse_rooms(area)
    end

    results

  end


  # 各部屋のデータのパース
  def parse_rooms(area)
    room_nodes = @browser.all(ROOMS::XPATH::ROOMS)

    rooms = room_nodes.map do |room_node|
      room_name = room_node.find(ROOMS::XPATH::ROOM_NAME_SUB)
      room_url = room_node.find(ROOMS::XPATH::ROOM_URL_SUB)

      room = Room.new
      room.target_area = area

      room.title = room_name.text
      original_url = room_url["href"]
      url = ''
      if original_url.present?
        split = original_url.split('?')
        if split.present?
          url = split[0]
        end
      end
      room.url = url

      reg_result = ROOMS::REGEX::AIR_BNB_ID.match room.url
      if reg_result.present? and reg_result[1].present?
        room.airbnb_id = reg_result[1]
      end


      room
    end

    rooms.each do |room|
      # 部屋の詳細ページじゃないと取れない情報
      room_url = ROOM::HELPER.room_url(room.airbnb_id)
      @browser.go_to_page(room_url)


      node = @browser.find ROOM::XPATH::CATEGORY
      room.category= node.text

      node = @browser.find ROOM::XPATH::CAPACITY
      if node.present?
        room.capacity= node.text.gsub(/宿泊人数|\s/, '')
      end

      node = @browser.find ROOM::XPATH::BED_ROOM_NUMBER
      if node.present?
        room.bed_room_number = node.text.gsub(/ベッドルーム|\s/, '').to_i
      end

      node = @browser.find ROOM::XPATH::BED_NUMBER
      if node.present?
        room.bed_number= node.text.gsub(/ベッド数|\s/, '').to_i
      end

      node = @browser.find ROOM::XPATH::AREA_NAME
      if node.present?
        room.area_name= node.text
      end


      address = ''
      address_nodes = @browser.all ROOM::XPATH::ADDRESS
      address_nodes.each do |address_node|
        address += address_node.text
      end

      room.address = address
    end

    rooms

  end

end