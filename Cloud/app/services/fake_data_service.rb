class FakeDataService
  class << self
    include Faker

    def cyclical_bias(t, period)
      Math.sin(2 * Math::PI * t / period) * (Math::PI / period)
    end

    def random_step
      (rand * 2 - 1)
    end

    def targeting_bias(value, target, alpha = 0.8)
      (target - value) * alpha
    end

    def random_walk(collection)
      value = 0
      collection.each_with_index.map do |obj, t|
        [obj, value += yield(t, value)]
      end
    end

    def time_series(collection, period)
      random_walk(collection) do |t, value|
        (random_step + cyclical_bias(t, period) + targeting_bias(value, 0.5)) / 3
      end
    end

    def cooler(attributes = {})
      Location.new(cooler_attributes.merge(attributes))
    end

    def cooler_attributes
      {
        location_name: "#{Hacker.adjective} #{Hacker.noun}",
        bottom_temp_threshold: 0,
        top_temp_threshold: 5,
        description: Hacker.say_something_smart
      }
    end

    def user(attributes = {})
      User.new(user_attributes.merge(attributes)) do |u|
        u.password = 'password'
        u.password_confirmation = 'password'
        u.skip_confirmation!
      end
    end

    def user_attributes
      firstname = Name.first_name
      lastname = Name.last_name
      slug = Internet.slug("#{firstname} #{lastname}")
      email = Internet.safe_email(slug)
      {
        firstname: firstname,
        lastname: lastname,
        email: email,
        username: email,
        job_title: Name.title,
        phone: Number.number(10),
        time_zone: Address.time_zone,
        email_notification: Boolean.boolean,
        sms_notification: Boolean.boolean
      }
    end

    def unit(attributes = {})
      Unit.new(unit_attributes.merge(attributes))
    end

    def unit_attributes
      {
        name: Book.title,
        institution: Company.name,
        address: Address.street_address,
        address1: Address.secondary_address,
        state: Address.state,
        zipcode: Address.zip
      }
    end

    def temps(start_time = ::Time.current - 1.year, end_time = ::Time.current + 1.year, step = 1.hour)
      steps = (start_time.to_i..end_time.to_i).step(step)
      period = 1.day / step
      time_series(steps, period).map do |time, temp|
        SensorReading.new(reading_time: ::Time.zone.at(time), temp: temp * 5)
      end
    end

    def line_check_list(attributes = {})
      LineCheckList.new line_check_list_attributes.merge(attributes)
    end

    def line_check_list_attributes(items_count = 10)
      {
        name: Pokemon.location,
        line_check_schedules_attributes: [{ time: '9:00 AM' }, { time: '12:00 PM' }, { time: '3:00 PM' }],
        line_check_items_attributes: Array.new(items_count) { line_check_item_attributes }
      }
    end

    def line_check_item(attributes = {})
      LineCheckItem.new line_check_item_attributes.merge(attributes)
    end

    def line_check_item_attributes
      {
        name: Pokemon.name,
        temp_low: 0,
        temp_high: 5,
        description: Hipster.sentence
      }
    end

    def create_line_checks(list, days = 31)
      days.times do |d|
        list.schedules.each do |sched|
          check = list.checks.create(
            created_at: sched.time - d.days,
            completed_at: sched.time - d.days,
            completed_by: list.unit.users.first
          )
          check.readings.each { |r| r.update(temp: rand * 9 - 2) }
        end
      end
    end
  end
end
