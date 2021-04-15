require 'rails_helper'

RSpec.describe ValidateAttributePresence, type: :validate_param_interactor do
  before(:all) do
    class DummyValidateAttributePresence < ValidateAttributePresence
      protected

      def attribute
        'dummy'
      end
    end
  end

  subject { DummyValidateAttributePresence.call(params: { dummy: dummy }) }

  context 'when attribute is defined and not empty' do
    let(:dummy) { 'dummy' }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when attribute is not defined' do
    let(:dummy) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when attribute is empty' do
    let(:dummy) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
