class ActivitiesValidator < ActiveModel::Validator
  def validate(record)
    activities = record.activities
    activities.each do |activity|
      if (/\w+:\w+:(\d+|\*)/ =~ activity).nil?
        record.errors[:activities] << 'Need to be in the form controller:action:(siret or siren or *)'
      end
    end
  end
end


