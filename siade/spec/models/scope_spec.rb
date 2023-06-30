# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scope do
  describe '.all' do
    subject { described_class.all }

    it { is_expected.to be_present }
    it { is_expected.to include('scope1') }
  end
end
