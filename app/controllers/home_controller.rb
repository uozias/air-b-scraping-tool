class HomeController < ApplicationController
  def index


  end

  def rooms

    result = Worker.search_rooms

    render json: result

  end

  def prices

    result = Worker.search_prices

    render json: result
  end
end
