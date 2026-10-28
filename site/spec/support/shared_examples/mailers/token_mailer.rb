# frozen_string_literal: true

RSpec.shared_examples 'a token mailer' do |api_name, prolong_path_method|
  let(:api) { api_name.to_s }
  let(:authorization_request) do
    create(:authorization_request, :with_all_contacts, :with_tokens, api: api == 'entreprise' ? 'entreprise' : 'particulier')
  end
  let(:token) { authorization_request.token }
  let(:host) { api == 'entreprise' ? 'entreprise.api.gouv.fr' : 'particulier.api.gouv.fr' }
  let(:magic_link_subject) { api == 'entreprise' ? "Lien d'accès temporaire au jeton API Entreprise" : "Lien d'accès temporaire au jeton API Particulier" }

  %w[
    expiration_notice_90J
    expiration_notice_60J
    expiration_notice_30J
    expiration_notice_15J
    expiration_notice_7J
    expiration_notice_0J
  ].each do |method|
    describe "##{method}" do
      subject(:generate_email) { described_class.send(method, { token: }) }

      it 'generates an email' do
        expect { generate_email }.not_to raise_error
      end

      its(:to) { is_expected.to contain_exactly(authorization_request.demandeur.email) }

      it 'display demandeur full name' do
        expect(subject.html_part.decoded).to include(authorization_request.demandeur.full_name)
      end

      it 'has a link to datapass authorization_request copy' do
        path = send(prolong_path_method, id: authorization_request.id)
        expect(subject.html_part.decoded).to include(path)
      end

      it 'has a text part with the link to the prolongation' do
        path = send(prolong_path_method, id: authorization_request.id)
        expect(subject.text_part.decoded).to include(path)
      end
    end
  end

  describe '#magic_link' do
    subject(:mailer) { described_class.magic_link(magic_link, host) }

    let(:magic_link) { create(:magic_link, email:) }
    let(:magic_link_url) { token_show_magic_link_url(host:, access_token: magic_link.access_token) }
    let(:email) { 'muchemail@wow.com' }

    its(:subject) { is_expected.to eq("🔑 #{magic_link_subject}") }
    its(:to) { is_expected.to contain_exactly(email) }

    it 'contains the magic link to the token' do
      expect(subject.html_part.decoded).to include(magic_link_url)
      expect(subject.text_part.decoded).to include(magic_link_url)
    end

    it 'has a text part without HTML' do
      expect(subject.text_part.decoded).not_to include('<a ', '&nbsp;')
    end
  end

  describe '#banned' do
    subject(:mailer) { described_class.with(token:, recipients:, comment:).banned }

    let(:recipients) { ['user@example.com', 'other@example.com'] }
    let(:banned_subject) { api == 'entreprise' ? 'Votre token d\'accès API Entreprise a été banni' : 'Votre token d\'accès API Particulier a été banni' }

    before { token.update!(blacklisted_at: 1.month.from_now) }

    context 'without comment' do
      let(:comment) { nil }

      its(:subject) { is_expected.to eq("🔑⚠️ #{banned_subject}") }
      its(:to) { is_expected.to match_array(recipients) }

      it 'includes the intitule' do
        expect(subject.html_part.decoded).to include(authorization_request.intitule)
      end

      it 'includes the blacklist date' do
        blacklisted_date = token.blacklisted_at.in_time_zone.strftime('%d/%m/%Y')
        expect(subject.html_part.decoded).to include(blacklisted_date)
      end

      it 'does not include comment section' do
        expect(subject.html_part.decoded).not_to include('Commentaire de l\'administrateur')
      end
    end

    context 'with comment' do
      let(:comment) { 'Token was compromised' }

      it 'includes the comment' do
        expect(subject.html_part.decoded).to include('Commentaire de l\'administrateur')
        expect(subject.html_part.decoded).to include('Token was compromised')
        expect(subject.text_part.decoded).to include('Token was compromised')
      end
    end
  end
end
