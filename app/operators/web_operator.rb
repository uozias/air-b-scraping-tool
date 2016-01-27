class WebOperator

  include AsConstants


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

  def search
    result = false

    @browser.go_to_page(LOGIN::URL)

    @browser.input('東京', SEARCH::XPATH::LOCATION)
    @browser.click(SEARCH::XPATH::SUBMIT)

    check_nodes = @browser.all(SEARCH::XPATH::SUCCESS)
    if check_nodes.present?
      result = true
    end
    result
  end

  def rooms


    result = MethodResult.new

    max_page_num_node = @browser.find(ROOMS::XPATH::PAGE_MAX)
    if max_page_num_node.blank?

      # first page only

      result.content.append find_rooms
    else

      # multiple pages

      max_page_num = max_page_num_node.text.to_i
      (1..max_page_num.to_i).each do |number|

        url = ROOMS::HELPER.page_url(number)
        @browser.go_to_page url

        # パース
        result.content.append find_rooms

      end

    end


    result.result = true
    result

  end

  def find_rooms
    room_nodes = @browser.all(ROOMS::XPATH::ROOMS)

    room_nodes.map do |room_node|
      room_name = room_node.find(ROOMS::XPATH::ROOM_NAME_SUB)
      room_url = room_node.find(ROOMS::XPATH::ROOM_URL_SUB)

      room = Room.new

      room.title = room_name.text
      room.url = room_url["href"]

      reg_result = ROOMS::REGEX::AIR_BNB_ID.match room.url
      if reg_result.present? and reg_result[1].present?
        room.airbnb_id = reg_result[1]
      end

      room
    end
  end

end