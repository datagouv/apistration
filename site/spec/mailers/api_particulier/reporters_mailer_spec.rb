RSpec.describe APIParticulier::ReportersMailer do
  before do
    create(:user, email: 'user@yopmail.com')
    stub_credential(:api_particulier_reporters, {
      cnaf_: ['user@yopmail.com', 'api-particulier@yopmail.com'],
      pole_emploi_: [],
      other_: ['datapass@yopmail.com']
    })
  end

  describe '#submit' do
    subject(:mail) do
      described_class.with(groups: %w[cnaf_ pole_emploi_], authorization_request:).submit
    end

    let(:authorization_request) { create(:authorization_request, :with_demandeur) }

    it 'has a link to public id' do
      expect(mail.body.encoded).to include(authorization_request.public_id)
    end

    it 'sends an email to reporters associated to these groups' do
      expect(mail.bcc).to include('user@yopmail.com')
      expect(mail.bcc).to include('api-particulier@yopmail.com')
      expect(mail.bcc).not_to include('datapass@yopmail.com')
    end
  end
end
