RSpec.describe ApplicationOrganizer do
  Rails.application.eager_load!

  def self.admin_organizers
    ApplicationOrganizer.descendants.select { |organizer| organizer.name&.start_with?('Admin::') }
  end

  it 'guards the admin organizers' do
    expect(self.class.admin_organizers).to include(Admin::Tokens::Ban, Admin::Impersonations::Start)
  end

  admin_organizers.each do |organizer|
    it "requires #{organizer} to record an admin activity as its last step" do
      expect(organizer.organized.last).to eq(Admin::TrackActivity)
    end
  end
end
