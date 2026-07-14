require 'rails_helper'
require 'tmpdir'

RSpec.describe Datagouv::YmlUidWriter do
  let(:base_path) { Dir.mktmpdir }
  let(:api_dir) { File.join(base_path, 'api_entreprise') }
  let(:file_path) { File.join(api_dir, 'sample.yml') }
  let(:original_content) do
    <<~YAML
      ---
      fiche:
        - uid: 'inpi/rne/beneficiaires_effectifs'
          path: '/v3/inpi/rne/unites_legales/{siren}/beneficiaires_effectifs'
          data:
            description: |+
              Cette API délivre des données.
        - uid: "dgfip/liasses_fiscales"
          path: "/v4/dgfip/unites_legales/{siren}/liasses_fiscales/{year}"
    YAML
  end

  before do
    FileUtils.mkdir_p(api_dir)
    File.write(file_path, original_content)
  end

  after { FileUtils.remove_entry(base_path) }

  describe '#write' do
    subject(:write) { described_class.new(api: 'api_entreprise', uid: 'inpi/rne/beneficiaires_effectifs', base_path:).write('672cf6a701d8db401e4864be') }

    it 'inserts the datagouv_uid line right after the matching uid line, leaving the rest untouched' do
      write

      expect(File.read(file_path)).to eq(<<~YAML)
        ---
        fiche:
          - uid: 'inpi/rne/beneficiaires_effectifs'
            datagouv_uid: '672cf6a701d8db401e4864be'
            path: '/v3/inpi/rne/unites_legales/{siren}/beneficiaires_effectifs'
            data:
              description: |+
                Cette API délivre des données.
          - uid: "dgfip/liasses_fiscales"
            path: "/v4/dgfip/unites_legales/{siren}/liasses_fiscales/{year}"
      YAML
    end

    context 'when the entry already has a datagouv_uid line (self-heal a stale/404 id)' do
      let(:original_content) do
        <<~YAML
          ---
          fiche:
            - uid: 'inpi/rne/beneficiaires_effectifs'
              datagouv_uid: 'old-id'
              path: '/v3/inpi/rne/unites_legales/{siren}/beneficiaires_effectifs'
              data:
                description: |+
                  Cette API délivre des données.
            - uid: "dgfip/liasses_fiscales"
              path: "/v4/dgfip/unites_legales/{siren}/liasses_fiscales/{year}"
        YAML
      end

      it 'replaces the existing datagouv_uid line instead of duplicating it' do
        write

        content = File.read(file_path)
        datagouv_uid_lines = content.lines.grep(/datagouv_uid:/)

        expect(datagouv_uid_lines).to eq(["    datagouv_uid: '672cf6a701d8db401e4864be'\n"])
        expect(content).to eq(<<~YAML)
          ---
          fiche:
            - uid: 'inpi/rne/beneficiaires_effectifs'
              datagouv_uid: '672cf6a701d8db401e4864be'
              path: '/v3/inpi/rne/unites_legales/{siren}/beneficiaires_effectifs'
              data:
                description: |+
                  Cette API délivre des données.
            - uid: "dgfip/liasses_fiscales"
              path: "/v4/dgfip/unites_legales/{siren}/liasses_fiscales/{year}"
        YAML
      end
    end

    context 'when the api directory has multiple yml files' do
      let(:other_file_path) { File.join(api_dir, 'other.yml') }
      let(:other_content) do
        <<~YAML
          ---
          fiche:
            - uid: 'unrelated/provider/endpoint'
              path: '/v1/unrelated/provider/endpoint'
        YAML
      end

      before { File.write(other_file_path, other_content) }

      it 'finds and edits only the file that contains the target uid, leaving the other untouched' do
        write

        expect(File.read(file_path)).to eq(<<~YAML)
          ---
          fiche:
            - uid: 'inpi/rne/beneficiaires_effectifs'
              datagouv_uid: '672cf6a701d8db401e4864be'
              path: '/v3/inpi/rne/unites_legales/{siren}/beneficiaires_effectifs'
              data:
                description: |+
                  Cette API délivre des données.
            - uid: "dgfip/liasses_fiscales"
              path: "/v4/dgfip/unites_legales/{siren}/liasses_fiscales/{year}"
        YAML
        expect(File.read(other_file_path)).to eq(other_content)
      end
    end
  end

  describe '#remove' do
    subject(:remove) { described_class.new(api: 'api_entreprise', uid: 'inpi/rne/beneficiaires_effectifs', base_path:).remove }

    before { described_class.new(api: 'api_entreprise', uid: 'inpi/rne/beneficiaires_effectifs', base_path:).write('672cf6a701d8db401e4864be') }

    it 'removes the datagouv_uid line and restores the original content exactly' do
      remove

      expect(File.read(file_path)).to eq(original_content)
    end
  end

  describe 'when the uid is not found in any file for that api' do
    subject(:write) { described_class.new(api: 'api_entreprise', uid: 'does/not/exist', base_path:).write('some-id') }

    it 'raises an error naming the missing uid' do
      expect { write }.to raise_error(Datagouv::YmlUidWriter::UidNotFoundError, %r{does/not/exist})
    end
  end
end
