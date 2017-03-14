module LineCheckSchedulesHelper
  def schedule_links(schedules)
    schedules.sort_by { |sched| sched.time.strftime('%H%M') }.map do |sched|
      sched.time.strftime('%l:%M %p')
    end
  end
end
