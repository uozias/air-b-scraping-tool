module AsConstants


  module LOGIN

    URL   = "https://www.airbnb.jp/"

    module XPATH
      SHOW = '//a[@href="/login"]'

      EMAIL = '//*[@name="email"]'
      PASSWORD = '//*[@name="password"]'

      SUBMIT = '//*[@id="user-login-btn"]'

      SUCCESS = '//span[text()="メッセージ"]'


    end

  end

  module SEARCH

    module XPATH

      LOCATION = '//*[@id="location"]'

      SUBMIT = '//*[@id="submit_location"]'

      SUCCESS = '//*[@id="map"]'

    end

    module HELPER

      def area_url(area_name, page_num, checkin, checkout)
        escaped = CGI.escape area_name
        "https://www.airbnb.jp/s/#{escaped}?checkin=#{checkin}&checkout=#{checkout}&page=#{page_num}"
      end

      module_function :area_url

    end

  end

  module ROOMS

    module REGEX

      AIR_BNB_ID = /\/rooms\/(\d+)/

    end


    module XPATH


      PAGE_MAX = "//*[contains(@class, 'pagination')]//li[contains(@class, 'next_page')]/preceding-sibling::*[1]/a"

      # 1つ1つの部屋
      ROOMS = "//*[@class='listing']"

      # 部屋名
      ROOM_NAME_SUB = "div//h3"

      ROOM_URL_SUB = "div//a[@class='text-normal']"


    end

    module HELPER



    end

  end

  module ROOM

    module XPATH

      CATEGORY = "//*[@class='summary-component']//div[@class='row'][2]//div[contains(@data-reactid, '$0')]"

      CAPACITY = "//*[@class='summary-component']//div[@class='row'][2]//div[contains(text(), '宿泊人数')]"

      BED_ROOM_NUMBER = "//*[@class='summary-component']//div[@class='row'][2]//div[contains(text(), 'ベッドルーム')]"

      BED_NUMBER ="//*[@class='summary-component']//div[@class='row'][2]//div[contains(text(), 'ベッド数')]"

      AREA_NAME = "//*[@id='neighborhood-seo-link']//h3[@class='seo-text']"

      ADDRESS = "//*[@id='hover-card']//*[@class='listing-location']//span"
    end

    module HELPER
      def room_url(airbnb_id, checkin=nil, checkout=nil)
        url = "https://www.airbnb.jp/rooms/#{airbnb_id}?"

        if checkin.present? and checkout.present?
          url +=  'checkin'+checkin + '&checkout=' + checkout
        end

        url

      end

      module_function :room_url
    end

  end






end