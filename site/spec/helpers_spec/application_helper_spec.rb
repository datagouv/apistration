require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#auto_link' do
    it 'yields each detected URL to the given block' do
      result = helper.auto_link('See https://example.com for details') { |url| "#{url}(new tab)" }

      expect(result).to include('https://example.com(new tab)')
    end
  end
end
