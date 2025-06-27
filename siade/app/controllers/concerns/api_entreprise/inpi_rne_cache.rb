module APIEntreprise::INPIRNECache
  def expires_in
    (Time.zone.now.end_of_day + 3.hours - Time.zone.now).to_i
  end
end
