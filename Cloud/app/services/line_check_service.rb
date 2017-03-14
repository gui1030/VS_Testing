class LineCheckService < ApplicationService
  CREATION_WINDOW = 15.minutes
  class << self
    def create_line_checks!(time)
      schedules = LineSchedule.where('time < ?', time + CREATION_WINDOW)
      schedules.each do |schedule|
        schedule.transaction do
          create_line_check!(schedule) if schedule.time >= time
          update_time! schedule, time
        end
      end
    end

    # Advances the schedule time until the day after the time being checked
    def update_time!(schedule, time)
      days = ((time - schedule.time) / 1.day).ceil
      schedule.update!(time: schedule.time.advance(days: [days, 1].max))
      logger.info { "Updated #{schedule.inspect}" }
    end

    def create_line_check!(schedule)
      line_check = schedule.line_check_list.line_checks.create!(line_check_items: schedule.line_check_items)
      logger.info { "Created #{line_check.inspect}" }
    end
  end
end
