RSpec.describe CodeToFormeJuridiqueService do
  describe "#forme_juridique" do
    it "return forme juridique for a given code" do
      expect(CodeToFormeJuridiqueService.forme_juridique("3120")).to eq("Société commerciale étrangère immatriculée au RCS")
    end
  end
end
