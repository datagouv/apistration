require 'rake'

RSpec.describe 'editor_delegation_requests:import', type: :rake do
  subject(:import) { task.invoke(editor_use_case.id, input_path, output_path) }

  let(:task) { Rake::Task['editor_delegation_requests:import'] }
  let(:editor_use_case) { create(:editor_use_case, editor: create(:editor, name: 'Omnikles ')) }
  let(:directory) { Dir.mktmpdir }
  let(:input_path) { File.join(directory, 'omnikles.csv') }
  let(:output_path) { File.join(directory, 'links.csv') }

  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    task.reenable

    File.write(input_path, "siret,contact_email\n21340172201787,achats@saint-exemple.fr\n213401722,siren@exemple.fr\n")

    stub_datapass_formulaires
    allow(UpdateOrganizationINSEEPayloadJob).to receive(:perform_later)
  end

  after { FileUtils.remove_entry(directory) }

  it 'writes the invitation links of the imported requests' do
    expect { import }.to output(/Created: 1.*Invalid SIRET \(1\): 213401722/m).to_stdout

    editor_delegation_request = EditorDelegationRequest.sole
    links = CSV.read(output_path, headers: true).map(&:to_h)

    expect(links).to eq(
      [
        {
          'siret' => '21340172201787',
          'contact_email' => 'achats@saint-exemple.fr',
          'url' => "#{ProConnectConfig.host('entreprise')}/editeurs/omnikles/habilitation/#{editor_delegation_request.generate_token_for(:invitation)}"
        }
      ]
    )
  end
end
