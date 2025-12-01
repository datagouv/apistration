RSpec.describe GIPMDS::Effectifs::MakeRequest, type: :make_request do
  subject { described_class.call(token:, params:) }

  let(:token) { GIPMDS::Authenticate.call.token }
  let(:siren) { valid_siren }
  let(:year) { '2020' }
  let(:params) do
    {
      nature: :yearly,
      siren:,
      year:
    }
  end

  before do
    Timecop.freeze(Time.zone.local(2019, 1, 1, 12, 0, 0))

    mock_gip_mds_authenticate
  end

  after do
    Timecop.return
  end

  it_behaves_like 'a make request with working mocking_params'

  describe 'for annual data' do
    let!(:stubbed_request) do
      stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/rcd-api/1.0.0/effectifs").with(
        query: {
          codeOPSDemandeur: '00000DINUM',
          dateHeure: '2019-01-01T12:00:00+01:00',
          source: 'RA;RG',
          nature: 'A01',
          siren:,
          periode: "#{year}1231"
        },
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }
      ).and_return(
        status: 200
      )
    end

    let(:year) { '2020' }
    let(:siren) { valid_siren }
    let(:params) do
      {
        nature: :yearly,
        siren:,
        year:
      }
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls endpoint with valid params' do
      subject

      expect(stubbed_request).to have_been_requested
    end

    context 'with nature_effectif parameter' do
      let(:params) do
        {
          nature: :yearly,
          siren:,
          year:,
          nature_effectif: 'boeth'
        }
      end

      let!(:stubbed_request) do
        stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/rcd-api/1.0.0/effectifs").with(
          query: {
            codeOPSDemandeur: '00000DINUM',
            dateHeure: '2019-01-01T12:00:00+01:00',
            source: 'RA;RG',
            nature: 'A02',
            siren:,
            periode: "#{year}1231"
          },
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{token}"
          }
        ).and_return(
          status: 200
        )
      end

      it 'calls endpoint with correct nature code' do
        subject

        expect(stubbed_request).to have_been_requested
      end
    end
  end

  describe 'for monthly data' do
    let!(:stubbed_request) do
      stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/rcd-api/1.0.0/effectifs").with(
        query: {
          codeOPSDemandeur: '00000DINUM',
          dateHeure: '2019-01-01T12:00:00+01:00',
          source: 'RA;RG',
          nature: 'M01',
          siret:,
          periode: "#{year}#{month}01",
          profondeurHistorique: depth
        }.compact,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }
      ).and_return(
        status: 200
      )
    end

    let(:params) do
      {
        nature: :monthly,
        siret:,
        year:,
        month:,
        depth:
      }
    end

    let(:year) { '2020' }
    let(:month) { '01' }
    let(:siret) { valid_siret }
    let(:depth) { nil }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls endpoint with valid params' do
      subject

      expect(stubbed_request).to have_been_requested
    end

    context 'with depth' do
      let(:depth) { 3 }

      it 'calls endpoint with params' do
        subject

        expect(stubbed_request).to have_been_requested
      end
    end

    context 'with nature_effectif parameter' do
      let(:params) do
        {
          nature: :monthly,
          siret:,
          year:,
          month:,
          depth:,
          nature_effectif: 'boeth'
        }
      end

      let!(:stubbed_request) do
        stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/rcd-api/1.0.0/effectifs").with(
          query: {
            codeOPSDemandeur: '00000DINUM',
            dateHeure: '2019-01-01T12:00:00+01:00',
            source: 'RA;RG',
            nature: 'M02',
            siret:,
            periode: "#{year}#{month}01"
          },
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{token}"
          }
        ).and_return(
          status: 200
        )
      end

      it 'calls endpoint with correct nature code' do
        subject

        expect(stubbed_request).to have_been_requested
      end
    end
  end
end
