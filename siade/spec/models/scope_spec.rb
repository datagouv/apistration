# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scope do
  describe '.all' do
    subject { described_class.all }

    it { is_expected.to be_present }
    it { is_expected.to include('scope1') }
  end

  describe '.all_for_api' do
    context 'with api whatever' do
      subject { described_class.all_for_api('api_whatever') }

      it { is_expected.to be_present }
      it { is_expected.to include('scope1') }
      it { is_expected.not_to include('men_echelon_bourse') }
    end
  end
end
