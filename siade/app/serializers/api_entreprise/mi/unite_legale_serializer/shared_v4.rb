class APIEntreprise::MI::UniteLegaleSerializer::SharedV4 < APIEntreprise::V3AndMore::BaseSerializer
  # rubocop:disable Metrics/MethodLength, Metrics/BlockLength, Metrics/AbcSize
  def self.inherited(subclass)
    subclass.class_eval do
      %i[
        rna
        ancien_id
        siren
        nom
        sigle
        reconnue_utilite_publique
        siret_siege
        forme_juridique
        regime
        groupement
        eligibilite_cec
        raison_non_eligibilite_cec
        alsace_moselle
        impots_commerciaux
        date_dissolution
        date_publication_reconnue_utilite_publique
        date_publication_journal_officiel
      ].each do |attr|
        attribute attr do |object|
          object.identite[attr]
        end
      end

      attribute :active do |object|
        object.identite[:active] &&
          object.identite[:active_sirene]
      end

      attribute :date_creation do |object|
        object.identite[:date_creation_rna] ||
          object.identite[:date_creation_sirene]
      end

      attributes :adresse_siege,
        :composition_reseau,
        :agrements,
        :adresse_gestion,
        :activites

      link :insee_siege_social do |object|
        next unless object.identite[:siret_siege]

        url_for(
          controller: 'api_entreprise/v3_and_more/insee/etablissements',
          action: :show,
          api_version: '3',
          siret: object.identite[:siret_siege]
        )
      end

      link :insee_siege_social_adresse do |object|
        next unless object.identite[:siret_siege]

        url_for(
          controller: 'api_entreprise/v3_and_more/insee/adresses_etablissements',
          action: :show,
          api_version: '3',
          siret: object.identite[:siret_siege]
        )
      end

      meta do |object|
        {
          internal_id: object.identite[:internal_id],
          date_derniere_mise_a_jour_sirene: object.identite[:date_derniere_mise_a_jour_sirene],
          date_derniere_mise_a_jour_rna: object.identite[:date_derniere_mise_a_jour_rna]
        }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/BlockLength, Metrics/AbcSize
end
