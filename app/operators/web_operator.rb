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

    max_page_num_node = @browser.find(ROOMS::XPATH::PAGE_MAX)
    if max_page_num_node.blank?
      puts 'max page number was not found'
      return
    end

    max_page_num = max_page_num_node.content
    (1..max_page_num.to_i).each do |number|

      url = ROOMS::HELPER.page_url(number)
      @browser.go_to_page url


    end


  end

end