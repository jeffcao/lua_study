class ChartController < ApplicationController
  def index

    @year="1996"
    @count = 70
    @shuzu = [[1, 0],[2, 40],[3, 60],[4, 65],[5, 50],[6, 50],[7, 60],[8, 80],[9, 150],[10, 0]]
  end
end
