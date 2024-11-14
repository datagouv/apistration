module APIEntreprise::CommonDGFIPOrganizerParams
  def common_dgfip_organizer_params
    {
      user_id: current_user.id,
      request_id: request.request_id
    }
  end
end
