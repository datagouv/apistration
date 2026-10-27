class EditorDelegation::TrackRevocations < ApplicationInteractor
  def call
    Array(context.revoked_delegations).each do |delegation|
      EditorDelegation::TrackRevocation.call(delegation:, delegation_revocation_source: context.delegation_revocation_source)
    end
  end
end
