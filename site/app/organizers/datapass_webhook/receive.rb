class DatapassWebhook::Receive < ApplicationOrganizer
  organize DatapassWebhook::VerifySignature
end
