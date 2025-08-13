# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ANTSRegistrationMatcherService do
  subject(:service) { described_class.new(context:) }

  let(:non_matching_result) do
    {
      success: false,
      type_match: nil,
      identite_from_ants: nil,
      address_from_ants: nil
    }
  end

  let(:identite) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      sexe_etat_civil: 'M',
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8,
      code_cog_insee_commune_naissance: '59001'
    }
  end

  let(:context) do
    Interactor::Context.new(
      response: instance_double(Net::HTTPOK, body: ants_payload),
      params: identite.merge(other_params)
    )
  end

  let(:other_params) { { immatriculation: 'TT-939-WA' } }

  let(:matching_result) do
    {
      success: true,
      type_match: 'titulaire',
      identite_from_ants: {
        nom_naissance: 'DUPONT',
        prenoms: ['JEAN'],
        sexe_etat_civil: 'M',
        annee_date_naissance: 1955,
        mois_date_naissance: 12,
        jour_date_naissance: 8,
        code_departement_naissance: '59'
      },
      address_from_ants: {
        num_voie: '12',
        type_voie: 'AVENUE',
        libelle_voie: 'DES CHAMPS',
        code_postal_ville: '59000',
        libelle_commune: 'LILLE',
        pays: 'FRANCE'
      }
    }
  end

  context 'with SIV payload' do
    let(:ants_payload) { read_payload_file('ants/found_siv.xml') }

    context 'when identite corresponds to the payload' do
      its(:match_data) { is_expected.to eq(matching_result) }

      it { is_expected.to be_match }
    end

    context 'when identite differs from the payload' do
      let(:identite) do
        {
          nom_naissance: 'DIFFERENT',
          prenoms: ['JEAN'],
          sexe_etat_civil: 'M',
          annee_date_naissance: 1955,
          mois_date_naissance: 12,
          jour_date_naissance: 8,
          code_cog_insee_commune_naissance: '59001'
        }
      end

      its(:match_data) { is_expected.to eq(non_matching_result) }

      it { is_expected.not_to be_match }
    end
  end

  context 'with FNI payload' do
    let(:ants_payload) { read_payload_file('ants/found_fni.xml') }

    let(:identite) do
      {
        nom_naissance: 'MARTIN',
        prenoms: ['MARIE'],
        sexe_etat_civil: 'F',
        annee_date_naissance: 1946,
        mois_date_naissance: 3,
        jour_date_naissance: 31,
        code_cog_insee_commune_naissance: '74501'
      }
    end

    let(:matching_result) do
      {
        success: true,
        type_match: 'locataire',
        identite_from_ants: {
          nom_naissance: 'MARTIN',
          prenoms: ['MARIE'],
          sexe_etat_civil: 'F',
          annee_date_naissance: 1946,
          mois_date_naissance: 3,
          jour_date_naissance: 31,
          code_departement_naissance: '74'
        },
        address_from_ants: {
          libelle_voie: 'DE LA REPUBLIQUE',
          code_postal_ville: '74000',
          libelle_commune: 'ANNECY',
          pays: 'FRANCE'
        }
      }
    end

    context 'when identite corresponds to the payload' do
      its(:match_data) { is_expected.to eq(matching_result) }

      it { is_expected.to be_match }
    end

    context 'when identite differs from the payload' do
      let(:identite) do
        {
          nom_naissance: 'DIFFERENT',
          prenoms: ['MARIE'],
          sexe_etat_civil: 'F',
          annee_date_naissance: 1946,
          mois_date_naissance: 3,
          jour_date_naissance: 31,
          code_cog_insee_commune_naissance: '74501'
        }
      end

      its(:match_data) { is_expected.to eq(non_matching_result) }

      it { is_expected.not_to be_match }
    end
  end
end
