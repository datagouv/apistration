RSpec.describe 'Errors nomenclature freshness', type: :acceptance do
  %i[entreprise particulier].each do |api|
    it "has commons/data/errors_#{api}.yml in sync with the service" do
      published = YAML.load_file(Rails.root.join("config/errors_#{api}.yml"), aliases: true)

      expect(published).to eq(ErrorsNomenclature.new(api).to_h),
        "config/errors_#{api}.yml is stale, run siade/bin/generate_errors_nomenclature.rb"
    end
  end
end
