class Chart
  FILTER_THRESHOLD = 500

  attr_accessor :relation, :x, :y

  def initialize(relation, x, y)
    self.relation = relation
    self.x = x
    self.y = y
  end

  def series
    data = relation
           .where.not(y => nil)
           .pluck(x, y)
    select_optima(data)
  end

  private

  def select_optima(data)
    optima = data
    window_size = 3
    while optima.size > FILTER_THRESHOLD
      optima = data.each_cons(window_size).each_with_object([]) do |window, acc|
        y = window.map(&:second)
        point = window[window.size / 2]
        acc << point if point.second == y.max || point.second == y.min
      end
      optima = [data.first] + optima + [data.last]
      window_size = window_size * 2 - 1
    end
    optima
  end
end
