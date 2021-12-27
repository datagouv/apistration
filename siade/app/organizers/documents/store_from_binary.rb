class Documents::StoreFromBinary < ApplicationOrganizer
  organize Documents::ValidateFormat,
    Documents::Upload
end
