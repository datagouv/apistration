class Admin::FacilitatorsController < AdminController
  def show
    @facilitators_url = "#{APIParticulier::BASE_URL}#{api_particulier_facilitators_path}"
    @password = APIParticulier::FacilitatorsPassword.value
  end
end
