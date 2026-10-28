require 'rails_helper'

RSpec.describe SecurityEvent, '.catalog' do
  Rails.application.eager_load!

  def self.tracking_organizers
    ApplicationOrganizer.descendants.select { |organizer| organizer < SecurityEvent::Tracking }
  end

  let(:catalog) { described_class.catalog }
  let(:siade_events) { catalog['events'].select { |_, declaration| declaration['services'].include?('siade') } }
  let(:tracked_events) { self.class.tracking_organizers.map(&:security_event_name).uniq }

  it 'declares for siade every event tracked by siade' do
    expect(tracked_events - siade_events.keys).to be_empty
  end

  it 'tracks every event declared for siade' do
    expect(siade_events.keys - tracked_events).to be_empty
  end

  tracking_organizers.each do |organizer|
    it "requires #{organizer} to end with SecurityEvent::Track" do
      expect(organizer.organized.last).to eq(SecurityEvent::Track)
    end
  end

  it 'emits only through SecurityEvent::Track' do
    emitters = Rails.root.glob('{app,config,lib}/**/*.rb').select { |file| File.read(file).include?('SecurityEvent.emit') }

    expect(emitters).to contain_exactly(Rails.root.join('app/interactors/security_event/track.rb'))
  end

  it 'names the details of siade events so that the parameter filters let them through' do
    parameter_filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
    detail_keys = siade_events.values.flat_map { |declaration| declaration.fetch('details', []) } + catalog['common_details']

    masked_keys = detail_keys.uniq.reject do |key|
      parameter_filter.filter(details: { key => 'value' }) == { details: { key => 'value' } }
    end

    expect(masked_keys).to be_empty
  end
end
