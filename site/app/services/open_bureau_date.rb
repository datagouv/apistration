class OpenBureauDate
  include DateAndTime::Calculations

  def next_date
    date = next_theoretical_date

    date = date.next_occurring(:thursday).next_occurring(:thursday) while cancelled_dates.include?(date)

    date
  end

  private

  def next_theoretical_date
    return Time.zone.today if open_bureau_today?

    next_thursday = Time.zone.today.next_occurring(:thursday)

    return next_thursday if first_or_third_thursday_in_month?(next_thursday)

    next_thursday.next_occurring(:thursday)
  end

  def cancelled_dates
    YAML.load_file(Rails.root.join('config/cancelled_open_bureau_dates.yml')).map(&:to_date)
  end

  def open_bureau_today?
    today = Time.zone.today

    today.thursday? && first_or_third_thursday_in_month?(today) && before_open_bureau_time?
  end

  def before_open_bureau_time?
    Time.zone.now < '11:00 am'.in_time_zone(Time.zone)
  end

  def first_or_third_thursday_in_month?(date)
    return false unless date.thursday?

    first_of_month = date.beginning_of_month

    first_thursday = first_of_month + ((4 - first_of_month.wday) % 7)

    third_thursday = first_thursday.next_occurring(:thursday).next_occurring(:thursday)

    date == first_thursday || date == third_thursday
  end
end
