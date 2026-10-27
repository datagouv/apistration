class EditorDelegation::Withdraw < ApplicationOrganizer
  before do
    context.delegation_revocation_source = 'applicant'
  end

  organize EditorDelegation::Revoke,
    EditorDelegation::TrackRevocation
end
