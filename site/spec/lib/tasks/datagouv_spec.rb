require 'rails_helper'

RSpec.describe 'datagouv rake tasks', type: :rake do
  before(:all) do
    Rails.application.load_tasks unless Rake::Task.task_defined?('datagouv:sync')
  end

  after do
    Rake::Task['datagouv:sync'].reenable
    Rake::Task['datagouv:sync_all'].reenable
  end

  describe 'datagouv:sync' do
    subject(:invoke) { Rake::Task['datagouv:sync'].invoke(*bracket_arg) }

    let(:bracket_arg) { [] }
    let(:runner) { instance_double(Datagouv::SyncRunner, call: true) }

    before { allow(Datagouv::SyncRunner).to receive(:new).and_return(runner) }

    context 'when SYNC_UIDS is set (the real GitHub Actions invocation path)' do
      before { ENV['SYNC_UIDS'] = 'inpi/rne/beneficiaires_effectifs,education_nationale/statut_eleve_scolarise' }
      after { ENV.delete('SYNC_UIDS') }

      it 'builds SyncRunner with only the matching endpoints from both catalogs' do
        invoke

        expect(Datagouv::SyncRunner).to have_received(:new) do |endpoints|
          expect(endpoints.map(&:uid)).to contain_exactly('inpi/rne/beneficiaires_effectifs', 'education_nationale/statut_eleve_scolarise')
        end
      end

      context 'when SyncRunner reports a failure' do
        let(:runner) { instance_double(Datagouv::SyncRunner, call: false) }

        it 'exits with a non-zero status' do
          expect { invoke }.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
        end
      end
    end

    context 'when SYNC_UIDS is not set and a single uid is passed via the bracket argument (manual CLI fallback)' do
      let(:bracket_arg) { ['inpi/rne/beneficiaires_effectifs'] }

      it 'falls back to the bracket argument' do
        invoke

        expect(Datagouv::SyncRunner).to have_received(:new) do |endpoints|
          expect(endpoints.map(&:uid)).to contain_exactly('inpi/rne/beneficiaires_effectifs')
        end
      end
    end
  end

  describe 'datagouv:sync_all' do
    subject(:invoke) { Rake::Task['datagouv:sync_all'].invoke }

    let(:runner) { instance_double(Datagouv::SyncRunner, call: true) }

    before { allow(Datagouv::SyncRunner).to receive(:new).and_return(runner) }

    it 'builds SyncRunner with every endpoint from both catalogs' do
      invoke

      expect(Datagouv::SyncRunner).to have_received(:new) do |endpoints|
        expect(endpoints.size).to eq(APIEntreprise::Endpoint.all.size + APIParticulier::Endpoint.all.size)
      end
    end
  end
end
