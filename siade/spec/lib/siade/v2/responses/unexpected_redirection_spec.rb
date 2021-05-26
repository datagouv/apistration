# frozen_string_literal: true

RSpec.describe SIADE::V2::Responses::UnexpectedRedirection, type: :provider_response do
  subject { SIADE::V2::Responses::UnexpectedRedirection.new(provider_name, redirect_response) }

  let(:redirect_response) do
    net_http_response = Net::HTTPResponse.new(1.0, 308, 'Redirect')
    net_http_response.add_field 'location', new_location
    net_http_response
  end
  let(:provider_name) { 'INSEE' }
  let(:new_location) { 'https://www.umadcorp.com' }

  before do
    allow(MonitoringService.instance).to receive(:track_provider_error_from_response).and_call_original
  end

  its(:http_code) { is_expected.to eq(502) }
  its(:errors) { is_expected.to have_error('Erreur serveur inattendue du fournisseur de données') }

  it 'adds redirect response location in monitoring context' do
    expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
      instance_of(SIADE::V2::Responses::UnexpectedRedirection),
      {
        redirect_location: new_location,
      },
    )

    subject
  end
end
