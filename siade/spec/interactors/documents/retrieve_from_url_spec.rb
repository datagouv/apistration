require 'rails_helper'

RSpec.describe Documents::RetrieveFromUrl do
  subject { described_class.call(retrieve_params.merge(provider_name: provider_name)) }

  let(:provider_name) { 'INSEE' }

  let(:retrieve_params) do
    { url: source_doc_url }
  end

  describe '.call' do
    let(:source_doc_url) { 'https://random.com/get_doc' }

    context 'when the source server responds with an HTTP success' do
      before do
        stub_request(:get, source_doc_url)
          .to_return(
            status: 200,
            body: 'much doc content'
        )
      end

      it { is_expected.to be_success }

      its(:content) { is_expected.to eq('much doc content') }
    end

    context 'when the source server responds with an HTTP error' do
      before do
        stub_request(:get, source_doc_url)
          .to_return(
            status: 404,
            body: 'Not Found'
        )
      end

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('Erreur lors de la récupération du document : status 404 with body \'Not Found\'') }
    end

    context 'when a timeout occurs downloading the document' do
      before { stub_request(:get, source_doc_url).to_timeout }

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('Temps d\'attente de téléchargement du document écoulé') }
    end

    context 'when the source URL is invalid' do
      let(:source_doc_url) { 'not an URL' }

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('L\'URL source du document chez le fournisseur de données est invalide : bad URI(is not URI?): "not an URL".') }
    end
  end
end
