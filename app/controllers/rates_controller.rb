class RatesController < ApplicationController
  def index
    @rates = Rate.all.order(date: :asc)
  end
end
