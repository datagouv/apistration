# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::V3AndMore::BaseSerializer, 'subclasses', type: :serializer do
  let(:root_keys_served_without_scope) do
    {
      'APIParticulier::FranceTravail::IndemnitesSerializer::V3' => %i[identifiant]
    }
  end

  let(:serializer_names) do
    Rails.root.glob('app/serializers/api_particulier/**/v*.rb')
      .select { |path| path.basename('.rb').to_s.delete_prefix('v').to_i >= 3 }
      .map { |path| Rails.autoloaders.main.cpath_expected_at(path) }
  end

  let(:user_without_scope) do
    JwtUser.new(uid: SecureRandom.uuid, scopes: [], jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i)
  end

  let(:provider_data_answering_anything) do
    Class.new {
      def method_missing(*) = nil
      def respond_to_missing?(*) = true
    }.new
  end

  def root_keys_rendered_without_scope(serializer_name)
    serializer_name.constantize.new(BundledData.new(data: provider_data_answering_anything), user_without_scope).serializable_hash[:data].keys
  end

  it 'finds every API Particulier v3 and more serializer' do
    expect(serializer_names).to include(
      'APIParticulier::CNAV::ParticipationFamilialeEAJE::V3',
      'APIParticulier::CNOUS::EtudiantBoursier::V5',
      'APIParticulier::MEN::ScolaritesSerializer::V5'
    )
  end

  it 'serves no root key to a token without scope, except the input parameters echoed back' do
    leaks = serializer_names.filter_map do |serializer_name|
      rendered = root_keys_rendered_without_scope(serializer_name)
      [serializer_name, rendered] unless rendered.sort == root_keys_served_without_scope.fetch(serializer_name, []).sort
    end

    expect(leaks).to be_empty, <<~MESSAGE
      Root keys rendered without scope (put each behind `if: -> { scope?(:...) }`, see docs/development/regles_de_conception.md):
      #{leaks.map { |name, keys| "  #{name}: #{keys.inspect}" }.join("\n")}
    MESSAGE
  end
end
