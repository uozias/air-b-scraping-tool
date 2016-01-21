class HomeController < ApplicationController
  def index

    Worker.execute

  end
end
