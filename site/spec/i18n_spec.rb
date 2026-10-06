# frozen_string_literal: true

require 'i18n/tasks'

RSpec.describe I18n do
  let(:i18n) { I18n::Tasks::BaseTask.new }
  let(:missing_keys) { i18n.missing_keys }
  let(:unused_keys) { i18n.unused_keys }
  let(:inconsistent_interpolations) { i18n.inconsistent_interpolations }
  let(:keys_with_new_tab_links_exposing_window_opener) do
    i18n.locales.flat_map { |locale| i18n.data[locale].leaves.to_a }.filter_map do |leaf|
      leaf.full_key if leaf.value.to_s.scan(/<a\b[^>]*target=['"]_blank['"][^>]*>/).any? { |tag| tag.exclude?('noopener') }
    end
  end

  it 'does not have missing keys' do
    expect(missing_keys).to be_empty,
      "Missing #{missing_keys.leaves.count} i18n keys, run `i18n-tasks missing' to show them"
  end

  it 'does not have unused keys' do
    expect(unused_keys).to be_empty,
      "#{unused_keys.leaves.count} unused i18n keys, run `i18n-tasks unused' to show them"
  end

  it 'does not have inconsistent interpolations' do
    error_message = "#{inconsistent_interpolations.leaves.count} i18n keys have inconsistent interpolations.\n" \
                    "Run `i18n-tasks check-consistent-interpolations' to show them"
    expect(inconsistent_interpolations).to be_empty, error_message
  end

  it 'does not open new tab links exposing window.opener' do
    expect(keys_with_new_tab_links_exposing_window_opener).to be_empty,
      "Add rel=\"noopener noreferrer\" to the target=\"_blank\" links of #{keys_with_new_tab_links_exposing_window_opener.join(', ')}"
  end
end
