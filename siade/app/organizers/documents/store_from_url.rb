class Documents::StoreFromUrl < ApplicationOrganizer
  organize Documents::RetrieveFromUrl,
    Documents::ValidateFormat,
    Documents::Upload
end
