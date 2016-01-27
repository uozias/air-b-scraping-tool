class Room < ActiveRecord::Base

  belongs_to :target_area

  validates_uniqueness_of :airbnb_id

  def go_to_page(browser)
    url = AsConstants::ROOMS::HELPER.room_url(self.airbnb_id)
    browser.go_to_page(url)
  end


end
