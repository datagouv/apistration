class ActivitiesValidator < ActiveModel::Validator
  def validate(record)
    activities = record.activities
    activities.each do |activity|
      record.errors[:activities] << 'Need to be in the form controller:action:(siret or siren or *)' if (/\w+:\w+:(\d+|\*)/ =~ activity).nil?
    end
  end
end
