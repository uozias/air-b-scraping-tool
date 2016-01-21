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


    module XPATH

      ROOM = ''

      PAGE_MAX = ''


    end

    module HELPER

      def page_url(page_num)
        "https://www.airbnb.jp/s/%E6%9D%B1%E4%BA%AC?page=#{page_num}"
      end

      module_function :page_url

    end

  end





end