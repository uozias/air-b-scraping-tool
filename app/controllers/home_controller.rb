class HomeController < ApplicationController
  def index

    result = Worker.execute

    render json: result
  end
end
