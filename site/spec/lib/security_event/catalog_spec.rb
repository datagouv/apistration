require 'rails_helper'

RSpec.describe SecurityEvent, '.catalog' do
  Rails.application.eager_load!

  def self.tracking_organizers
    ApplicationOrganizer.descendants.select { |organizer| organizer < SecurityEvent::Tracking }
  end

  let(:catalog) { described_class.catalog }
  let(:site_events) { catalog['events'].select { |_, declaration| declaration['services'].include?('site') }.keys }
  let(:tracked_events) { self.class.tracking_organizers.map(&:security_event_name).uniq }

  it 'declares every event tracked by site' do
    expect(tracked_events - catalog['events'].keys).to be_empty
  end

  it 'tracks every event declared for site' do
    expect(site_events - tracked_events).to be_empty
  end

  tracking_organizers.each do |organizer|
    it "requires #{organizer} to end with SecurityEvent::Track, before an admin activity" do
      steps = organizer.organized - [Admin::TrackActivity]

      expect(steps.last).to eq(SecurityEvent::Track)
    end
  end

  it 'emits only through SecurityEvent::Track' do
    emitters = Rails.root.glob('app/**/*.rb').select { |file| File.read(file).include?('SecurityEvent.emit') }

    expect(emitters).to contain_exactly(Rails.root.join('app/interactors/security_event/track.rb'))
  end

  it 'names events <domain>.<object>.<past participle> within the closed list of domains' do
    catalog['events'].each_key do |name|
      domain, = name.split('.')

      expect(name).to match(/\A[a-z_]+\.[a-z_]+\.[a-z_]+ed\z/)
      expect(catalog['domains']).to include(domain)
    end
  end

  it 'describes every event with the agreed schema' do
    catalog['events'].each do |name, declaration|
      expect(declaration.keys).to include('criticality', 'services', 'description', 'actor_types', 'target_type', 'since'), name
      expect(%w[critical notable info]).to include(declaration['criticality']), name
    end
  end
end
