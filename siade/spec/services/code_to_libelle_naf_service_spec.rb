RSpec.describe CodeToLibelleNafService do

  describe '.libelle' do
    it "return associate libelle to code naf given" do
      expect(CodeToLibelleNafService.libelle '0112Z').to eq("Culture du riz")
      expect(CodeToLibelleNafService.libelle '1813Z').to eq("Activités de pré-presse")
    end
  end
end
