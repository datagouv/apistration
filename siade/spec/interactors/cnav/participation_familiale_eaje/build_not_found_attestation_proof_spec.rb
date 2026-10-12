RSpec.describe CNAV::ParticipationFamilialeEAJE::BuildNotFoundAttestationProof do
  subject(:proof) do
    described_class.call(
      generate_proof_mode: 'pdf',
      recipient: '13002526500013',
      not_found_error: { 'title' => 'Allocataire non référencé', 'detail' => 'd', 'origin' => 'RNCPS' },
      params_as_sent: identity.merge(birth_date)
    )
  end

  let(:identity) { { nom_naissance: 'CHAMPION', prenoms: %w[JEAN], code_cog_insee_pays_naissance: '99134' } }

  def pdf_birth_date_row
    birth_date_row(proof.pdf_token, AttestationToken::PDF_PURPOSE)
  end

  def verification_birth_date_row
    birth_date_row(proof.verification_token, AttestationToken::VERIFICATION_PURPOSE)
  end

  def birth_date_row(token, purpose)
    AttestationToken.read(token, purpose:)['sections'].last['entrees'].first.assoc('Date de naissance')
  end

  shared_examples 'a birth date shown as sent, without the day on the verification page' do |on_pdf, on_verification_page|
    it "shows #{on_pdf} on the PDF and #{on_verification_page} on the verification page" do
      expect(pdf_birth_date_row).to eq(['Date de naissance', on_pdf])
      expect(verification_birth_date_row).to eq(['Date de naissance', on_verification_page])
    end
  end

  context 'with a full date' do
    let(:birth_date) { { annee_date_naissance: '1980', mois_date_naissance: '6', jour_date_naissance: '12' } }

    it_behaves_like 'a birth date shown as sent, without the day on the verification page', '12/06/1980', '06/1980'
  end

  context 'with a date without the day' do
    let(:birth_date) { { annee_date_naissance: '1980', mois_date_naissance: '6' } }

    it_behaves_like 'a birth date shown as sent, without the day on the verification page', '--/06/1980', '06/1980'
  end

  context 'with a date without the month' do
    let(:birth_date) { { annee_date_naissance: '1980', jour_date_naissance: '12' } }

    it_behaves_like 'a birth date shown as sent, without the day on the verification page', '12/--/1980', '--/1980'
  end

  context 'with a date without the year' do
    let(:birth_date) { { mois_date_naissance: '6', jour_date_naissance: '12' } }

    it_behaves_like 'a birth date shown as sent, without the day on the verification page', '12/06/----', '06/----'
  end

  context 'with a year only' do
    let(:birth_date) { { annee_date_naissance: '1980' } }

    it_behaves_like 'a birth date shown as sent, without the day on the verification page', '--/--/1980', '--/1980'
  end

  context 'without a birth date' do
    let(:birth_date) { {} }

    it 'shows no birth date row' do
      expect(pdf_birth_date_row).to be_nil
    end
  end
end
