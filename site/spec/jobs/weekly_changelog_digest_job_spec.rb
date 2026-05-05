require 'rails_helper'

RSpec.describe WeeklyChangelogDigestJob do
  include ActiveJob::TestHelper

  let(:reference_date) { Date.new(2026, 5, 11) }
  let(:previous_monday) { Date.new(2026, 5, 4) }
  let(:previous_sunday) { Date.new(2026, 5, 10) }

  before { clear_enqueued_jobs }

  def stub_entries(entries)
    allow(ChangelogEntry).to receive(:for).with(:api_entreprise).and_return(entries[:api_entreprise] || [])
    allow(ChangelogEntry).to receive(:for).with(:api_particulier).and_return(entries[:api_particulier] || [])
  end

  context 'with no subscriptions' do
    it 'does not enqueue any mailer' do
      stub_entries(api_entreprise: [build_entry('api_entreprise', previous_monday)])

      expect {
        described_class.perform_now(reference_date:)
      }.not_to change(enqueued_jobs, :size)
    end
  end

  context 'with subscribers and entries within the previous ISO week' do
    let!(:entreprise_subscription) { create(:changelog_subscription, scope: 'api_entreprise') }
    let!(:particulier_subscription) { create(:changelog_subscription, :api_particulier) }

    it 'enqueues a weekly mail per subscriber per scope' do
      stub_entries(
        api_entreprise: [build_entry('api_entreprise', previous_monday)],
        api_particulier: [build_entry('api_particulier', previous_sunday)]
      )

      expect {
        described_class.perform_now(reference_date:)
      }.to change(enqueued_jobs, :size).by(2)
    end

    it 'skips a scope when no entry was published' do
      stub_entries(
        api_entreprise: [build_entry('api_entreprise', previous_monday)],
        api_particulier: []
      )

      expect {
        described_class.perform_now(reference_date:)
      }.to change(enqueued_jobs, :size).by(1)
    end

    it 'skips disabled subscriptions' do
      entreprise_subscription.disable!
      particulier_subscription.disable!
      stub_entries(
        api_entreprise: [build_entry('api_entreprise', previous_monday)],
        api_particulier: [build_entry('api_particulier', previous_sunday)]
      )

      expect {
        described_class.perform_now(reference_date:)
      }.not_to change(enqueued_jobs, :size)
    end

    it 'ignores entries outside the previous ISO week' do
      stub_entries(
        api_entreprise: [build_entry('api_entreprise', reference_date)],
        api_particulier: [build_entry('api_particulier', previous_monday - 1.day)]
      )

      expect {
        described_class.perform_now(reference_date:)
      }.not_to change(enqueued_jobs, :size)
    end
  end

  def build_entry(scope, date)
    ChangelogEntry.new(date:, scope:, title: "Entry #{date}", description: 'desc')
  end
end
