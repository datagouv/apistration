RSpec.describe SIADE::V2::Retrievers::Associations do

  subject { described_class.new(valid_siren) }

  let(:driver) { SIADE::V2::Drivers::Associations }

  it { is_expected.to be_delegated_to(driver, :siren) }
  it { is_expected.to be_delegated_to(driver, :siret) }
  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :id) }
  it { is_expected.to be_delegated_to(driver, :titre) }
  it { is_expected.to be_delegated_to(driver, :objet) }
  it { is_expected.to be_delegated_to(driver, :siret_siege_social) }
  it { is_expected.to be_delegated_to(driver, :date_creation) }
  it { is_expected.to be_delegated_to(driver, :date_declaration) }
  it { is_expected.to be_delegated_to(driver, :date_publication) }
  it { is_expected.to be_delegated_to(driver, :date_dissolution) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_complement_1) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_complement_2) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_complement_3) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_numero_voie) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_type_voie) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_libelle_voie) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_distribution) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_code_insee) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_code_postal) }
  it { is_expected.to be_delegated_to(driver, :adresse_siege_commune) }
  it { is_expected.to be_delegated_to(driver, :code_civilite_dirigeant) }
  it { is_expected.to be_delegated_to(driver, :civilite_dirigeant) }
  it { is_expected.to be_delegated_to(driver, :code_etat) }
  it { is_expected.to be_delegated_to(driver, :etat) }
  it { is_expected.to be_delegated_to(driver, :code_groupement) }
  it { is_expected.to be_delegated_to(driver, :groupement) }
  it { is_expected.to be_delegated_to(driver, :mise_a_jour) }
  it 'should have an adresse_siege wrapper' do
    subject.retrieve
    expect(subject.adresse_siege[:numero_voie]  ).to eq(subject.adresse_siege_numero_voie)
    expect(subject.adresse_siege[:type_voie]    ).to eq(subject.adresse_siege_type_voie)
    expect(subject.adresse_siege[:libelle_voie] ).to eq(subject.adresse_siege_libelle_voie)
    expect(subject.adresse_siege[:distribution] ).to eq(subject.adresse_siege_distribution)
    expect(subject.adresse_siege[:code_insee]   ).to eq(subject.adresse_siege_code_insee)
    expect(subject.adresse_siege[:code_postal]  ).to eq(subject.adresse_siege_code_postal)
    expect(subject.adresse_siege[:commune]      ).to eq(subject.adresse_siege_commune)
  end
end
