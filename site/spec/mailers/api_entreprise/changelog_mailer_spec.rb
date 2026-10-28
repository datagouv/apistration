# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIEntreprise::ChangelogMailer do
  describe '#weekly' do
    subject(:mail) { described_class.weekly(subscription.id, entries) }

    let(:subscription) { create(:changelog_subscription, scope: 'api_entreprise') }
    let(:entries) do
      [
        { date: Date.new(2026, 5, 5), scope: 'api_entreprise', title: 'Nouvelle fiche', description: 'Lorem' }
      ]
    end

    it 'is sent to the subscriber' do
      expect(mail.to).to eq([subscription.user.email])
    end

    it 'has the localized subject' do
      expect(mail.subject).to eq('📰 Les nouveautés API Entreprise de la semaine')
    end

    it 'renders the entries' do
      expect(mail.body.encoded).to include('Nouvelle fiche')
    end

    it 'includes the unsubscribe token link' do
      expect(mail.html_part.body.decoded).to include(subscription.unsubscribe_token)
      expect(mail.text_part.body.decoded).to include(subscription.unsubscribe_token)
    end

    context 'when an entry links to a page of the site' do
      let(:entries) do
        [
          { date: Date.new(2026, 5, 5), scope: 'api_entreprise', title: 'Nouvelle fiche', description: 'Voir le [catalogue](<%= endpoints_path %>)' }
        ]
      end

      it 'renders the link as an absolute URL in the text part' do
        expect(mail.text_part.body.decoded).to include("[catalogue](http://#{ActionMailer::Base.default_url_options[:host]}/catalogue)")
      end
    end
  end
end
