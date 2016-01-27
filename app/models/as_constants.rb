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

      def area_url(area_name, page_num, checkin, checkout)
        "https://www.airbnb.jp/s/%E7%94%A8%E8%B3%80?checkin=2016%2F01%2F27&checkout=2016%2F01%2F28page=#{page_num}"
      end

      module_function :area_url

    end

  end





end