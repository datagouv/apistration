class Documents::StoreFromBase64 < ApplicationOrganizer
  organize Documents::Base64Decode,
    Documents::ValidateFormat,
    Documents::Upload
end
