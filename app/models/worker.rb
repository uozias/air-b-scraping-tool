class Worker

  include LogManager

  def self.execute



  end

  def self.search_rooms

    @operator = WebOperator.new

    areas = TargetArea.where(category: '駅')

    rooms = []
    areas.each do |area|

      search_result =  @operator.rooms(area)
      unless search_result
        write_log "searching #{area_name} was failed"
      end

      rooms.concat(search_result.content)
    end


    rooms.uniq! do |room|
      room.airbnb_id
    end
    Room.import rooms

    rooms

  end

  def self.search_prices

  end

end