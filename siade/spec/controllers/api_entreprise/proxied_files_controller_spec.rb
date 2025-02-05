RSpec.describe APIEntreprise::ProxiedFilesController do
  describe 'GET #show' do
    subject { get :show, params: { uuid: document_id } }

    let(:document_id) { SecureRandom.uuid }

    context 'when document is not found' do
      it { is_expected.to have_http_status(:not_found) }
    end

    context 'when backend raises a connection error' do
      before do
        allow(ProxiedFileService).to receive(:get).and_raise(ProxiedFileService::ConnectionError)
      end

      it { is_expected.to have_http_status(:service_unavailable) }
    end

    context 'when document exists in backend' do
      before do
        allow(ProxiedFileService).to receive(:get).and_return('https://example.com/url.pdf')
      end

      context 'when url renders a 200' do
        before do
          stub_request(:any, 'https://example.com/url.pdf').to_return(
            status: 200,
            body: Rails.root.join('spec/fixtures/dummy.pdf'),
            headers: {
              'Content-Type' => 'application/pdf',
              'Content-Disposition' => content_disposition
            }
          )
        end

        context 'when Content-Disposition header does not have a filename' do
          let(:content_disposition) { 'attachment' }

          it { is_expected.to have_http_status(:ok) }

          it 'renders this document, takes the filename from the URL' do
            subject

            expect(response.headers['Content-Disposition']).to include('attachment; filename="url.pdf"')
            expect(response.headers['Content-Type']).to eq('application/pdf')
            expect(response.body).to eq(Rails.root.join('spec/fixtures/dummy.pdf').binread)
          end
        end

        context 'when Content-Disposition header has a filename' do
          let(:content_disposition) { 'attachment; filename="content_disposition.pdf"' }

          it { is_expected.to have_http_status(:ok) }

          it 'renders this document, with filename from the Content-Disposition header' do
            subject

            expect(response.headers['Content-Disposition']).to include('attachment; filename="content_disposition.pdf"')
            expect(response.headers['Content-Type']).to eq('application/pdf')
            expect(response.body).to eq(Rails.root.join('spec/fixtures/dummy.pdf').binread)
          end
        end
      end

      context 'when url renders a 404' do
        before do
          stub_request(:any, 'https://example.com/url.pdf').to_return(
            status: 404
          )
        end

        it { is_expected.to have_http_status(:not_found) }
      end

      context 'when url renders a 504' do
        before do
          stub_request(:any, 'https://example.com/url.pdf').to_return(
            status: 504
          )
        end

        it { is_expected.to have_http_status(:bad_gateway) }

        it 'tracks the error as info' do
          expect(MonitoringService.instance).to receive(:track_with_added_context).with('info', 'Proxied file error', { status: '504', url: 'https://example.com/url.pdf' })

          subject
        end
      end
    end
  end
end
