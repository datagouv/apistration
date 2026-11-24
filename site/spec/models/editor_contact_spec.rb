RSpec.describe EditorContact do
  describe 'personal data anonymization in staging' do
    before { allow(Rails.env).to receive(:staging?).and_return(true) }

    it 'stores an anonymized contact' do
      contact = create(:editor_contact)

      expect(contact.reload.email).to match(/\Aanon-\h{12}@yopmail\.com\z/)
      expect(contact.phone).to eq('0100000000')
      expect(contact.full_name).to match(/\ANom \h{6}\z/)
    end
  end
end
