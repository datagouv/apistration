require 'rails_helper'

describe Documents::Upload, :self_hosted_doc do
  describe '.call' do
    subject { described_class.call(doc_params) }

    let(:doc_params) do
      {
        filename: 'test.lol',
        content: 'much content',
      }
    end

    context 'when upload works' do
      it { is_expected.to be_success }

      its(:url) do
        is_expected.to be_a_valid_self_hosted_document_url('test.lol')
      end
    end
  end
end
