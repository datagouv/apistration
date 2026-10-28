class EditorDelegation::Grant < ApplicationOrganizer
  before do
    context.delegation_source = 'applicant'
  end

  organize EditorDelegation::Create,
    EditorDelegation::TrackGrant
end
