RSpec.describe Infogreffe::ExtraitsRCSSchema14, type: :retriever_organizer do
  def v3(payload)
    stub_infogreffe_extrait_rcs(siren: valid_siren(:extrait_rcs), payload: "schema_1/#{payload}")

    Infogreffe::ExtraitsRCS.call(params: { siren: valid_siren(:extrait_rcs) })
  end

  def v4(payload)
    stub_infogreffe_extrait_rcs_schema_14(siren: valid_siren(:extrait_rcs), payload:)

    described_class.call(params: { siren: valid_siren(:extrait_rcs) })
  end

  def case_insensitive(adresse)
    adresse.transform_values { |value| I18n.transliterate(value).upcase }
  end

  describe 'EUID' do
    it 'exposes the EUID given by Infogreffe' do
      stub_request(:post, Siade.credentials[:infogreffe_url_extrait_rcs])
        .with(body: %r{<version_schema>14</version_schema>})
        .to_return(status: 200, body: open_payload_file('infogreffe/extrait_rcs_version_schema_14.xml'))

      expect(described_class.call(params: { siren: '919520908' }).bundled_data.data.euid).to eq('FR3302.919520908')
    end

    it 'exposes the EUID of the entreprise, not the empty one of its dirigeants personnes morales' do
      expect(v4('personne_morale').bundled_data.data.euid).to eq('FR2104.391784741')
    end

    it 'exposes no EUID for an entreprise individuelle, as Infogreffe sends none, rather than computing one' do
      expect(v4('personne_physique').bundled_data.data.euid).to be_nil
    end
  end

  describe 'same entreprise in v3 (schema 1) and v4 (schema 14), from real Infogreffe responses' do
    it 'gives the same address of the entreprise individuelle, case aside' do
      expect(case_insensitive(v4('personne_physique').bundled_data.data.personne_physique[:adresse]))
        .to eq(case_insensitive(v3('personne_physique').bundled_data.data.personne_physique[:adresse]))
    end

    it 'gives the same address of the siege, case aside' do
      expect(case_insensitive(v4('personne_morale').bundled_data.data.adresse_siege))
        .to eq(case_insensitive(v3('personne_morale').bundled_data.data.adresse_siege))
    end

    it 'gives the same mandataires sociaux, dirigeants personnes morales included' do
      keys = %i[type nom prenom numero_identification date_naissance]

      expect(v4('personne_morale').bundled_data.data.mandataires_sociaux.map { |mandataire| mandataire.slice(*keys) })
        .to eq(v3('personne_morale').bundled_data.data.mandataires_sociaux.map { |mandataire| mandataire.slice(*keys) })
    end

    it 'gives the same radiation date' do
      expect(v4('radiee').bundled_data.data.date_radiation).to eq('2019-03-13')
      expect(v3('radiee').bundled_data.data.date_radiation).to eq('2019-03-13')
    end

    it 'gives the same identity of the entreprise individuelle' do
      fields = ->(data) { [data.personne_physique[:nom], data.personne_physique[:prenom], data.personne_physique[:naissance]] }

      expect(fields.call(v4('personne_physique').bundled_data.data)).to eq(fields.call(v3('personne_physique').bundled_data.data))
    end

    it 'fails with a not found error on an unknown SIREN' do
      expect(v4('siren_not_found').errors).to include(instance_of(NotFoundError))
    end
  end
end
