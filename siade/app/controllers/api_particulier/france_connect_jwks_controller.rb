# frozen_string_literal: true

class APIParticulier::FranceConnectJwksController < ApplicationController
  def show
    jwks = {
      keys: [
        {
          kty: 'RSA',
          kid: 'api_particulier_rsa_oaep_jwks',
          use: 'enc',
          alg: 'RSA-OAEP',
          n: Base64.urlsafe_encode64(rsa_public_key.n.to_s(2)),
          e: Base64.urlsafe_encode64(rsa_public_key.e.to_s(2))
        }
      ]
    }

    render json: jwks.to_json
  end

  def token
    nil
  end

  private

  def rsa_public_key
    OpenSSL::PKey::RSA.new(Siade.credentials[:france_connect_v2_rsa_public])
  end
end
